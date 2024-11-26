import 'dart:core';
import 'dart:io';

import 'package:another_flushbar/flushbar_route.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:s_social/core/domain/model/message_model.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:uuid/uuid.dart';

import '../../../../../generated/l10n.dart';
import '../../../../screen/home/view/widget/full_screen_img.dart';
import '../logic/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic>? recipient;
  const ChatScreen({
    super.key,
    required this.recipient
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(chatRepository: serviceLocator(), uploadFileRepository: serviceLocator()),
      child: _ChatScreen(recipient: recipient),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  const _ChatScreen({required Map<String, dynamic>? recipient}) :
        _recipient = recipient;

  final Map<String, dynamic>? _recipient;
  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  // Create chat session id by joining the current user id and the recipient id
  final _auth = FirebaseAuth.instance;
  final messageCtrl = TextEditingController();
  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance.collection('messages').snapshots();
  final List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    context.read<ChatCubit>().getChatSession(_chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    final String chatId = _chatId;
    // Making a back button returning to the previous screen and a menu button that opens sideways
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._recipient?['email']),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(buildContext);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Open a menu

            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildContent(
              buildContext: buildContext,
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildContent({required BuildContext buildContext}) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ChatLoaded) {
          return _buildMessageList(
            buildContext: buildContext,
          );
        } else if (state is ChatError) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildMessageList({required BuildContext buildContext}) {
    return StreamBuilder(
      stream: buildContext.read<ChatCubit>().getMessageStream(_chatId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final messages = snapshot.data!.docs
            .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
            .toList();
          return _buildMessageListView(
            messages: messages,
            buildContext: buildContext
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
  
  Widget _buildMessageListView({
    required List<MessageModel> messages,
    required BuildContext buildContext
  }) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // If the previous message is from the same sender, don't show the sender's email
        int reversedIndex = messages.length - 1 - index;
        bool showSender = true;
        if (reversedIndex >= 1 && messages[reversedIndex].senderEmail == messages[reversedIndex - 1].senderEmail) {
          showSender = false;
        }
        return _buildMessageItem(
            message: messages[reversedIndex],
            showSender: showSender,
            msgContext: buildContext
        );
      },
    );
  }

  Widget _buildMessageInput() {
    final String chatId = _chatId;
    final String senderEmail = _auth.currentUser?.email ?? '';
    final String recipientEmail = widget._recipient?['email'] ?? '';
    List<String?>? urls = [];
    return MessageBar(
      messageBarHintText: S.of(context).type_message,
      onSend: (content) async {
        // If the message is empty, don't send
        if (content.isEmpty && _selectedImages.isEmpty) {
          return;
        }
        // Send images if exist to database
        if (_selectedImages.isNotEmpty) {
          urls = await context.read<ChatCubit>().uploadImagesToFirebase(_selectedImages);
        }
        // Send message to the chat session
        await context.read<ChatCubit>().sendMessage(
            chatId: chatId,
            senderEmail: senderEmail,
            recipientEmail: recipientEmail,
            content: content,
            images: urls,
        );
        _selectedImages.clear();
        urls?.clear();
      },
      actions: [
        InkWell(
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 24,
          ),
          onTap: () {
            // Make ripple effect and do something (Not implemented)
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: InkWell(
            onTap: _pickImageFromGallery,
            child: const Icon(
              Icons.photo_library_outlined,
              color: Colors.green,
              size: 24,
            ),
          ),
        ),
      ],  // Actions
    );
  }

  Future<void> _pickImageFromGallery() async {
    final String chatId = _chatId;
    final String senderEmail = _auth.currentUser?.email ?? '';
    final String recipientEmail = widget._recipient?['email'] ?? '';
    List<String?>? urls = [];

    _selectedImages.clear();
    final List<XFile?> pickedFile = await _imagePicker.pickMultiImage(
      imageQuality: 50,
      maxHeight: 1920,
      maxWidth: 1080,
    );
    setState(() async {
      if (pickedFile.isNotEmpty) {
        for (XFile? file in pickedFile) {
          if (file != null) {
            _selectedImages.add(File(file.path));
          }
        }
        urls = await context.read<ChatCubit>().uploadImagesToFirebase(_selectedImages);

        // Send message to the chat session
        await context.read<ChatCubit>().sendMessage(
          chatId: chatId,
          senderEmail: senderEmail,
          recipientEmail: recipientEmail,
          content: null,
          images: urls,
        );
        _selectedImages.clear();
        urls?.clear();

        // Showing a elevated button to send the images
        // This button will be shown only if there are images selected
        // ElevatedButton(
        //   onPressed: () {
        //     // Send images to the chat session
        //     if (_selectedImages.isNotEmpty) {
        //       urls = context.read<ChatCubit>().uploadImagesToFirebase(_selectedImages) as List<String?>?;
        //     }
        //     context.read<ChatCubit>().sendMessage(
        //         chatId: chatId,
        //         senderEmail: senderEmail,
        //         recipientEmail: recipientEmail,
        //         content: "",
        //         images: urls
        //     );
        //     _selectedImages.clear();
        //   },
        //   child: Text(S.of(context).send),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).no_image_selected),
          ),
        );
      }
    });
  }

  String get _chatId {
    final String currentUserId = _auth.currentUser?.uid ?? '';
    final String recipientId = widget._recipient?['id'] ?? '';
    List<String> userIds = [currentUserId, recipientId];
    userIds.sort();
    return userIds.join('-');
  }

  Widget _buildMessageItem({
    required MessageModel message,
    required bool showSender,
    required BuildContext msgContext
  }) {
    Alignment alignment;
    Color color;
    CrossAxisAlignment crossAxisAlignment;
    MainAxisAlignment mainAxisAlignment;
    bool isSender;
    if (message.senderEmail == _auth.currentUser?.email) {
      alignment = Alignment.centerRight;
      color = Colors.blue[100]!;
      crossAxisAlignment = CrossAxisAlignment.end;
      mainAxisAlignment = MainAxisAlignment.end;
      isSender = true;
    } else {
      alignment = Alignment.centerLeft;
      color = Colors.grey[200]!;
      crossAxisAlignment = CrossAxisAlignment.start;
      mainAxisAlignment = MainAxisAlignment.start;
      isSender = false;
    }

    EdgeInsets edgeInsets = EdgeInsets.zero;
    bool showTail = false;
    if (showSender) {
      edgeInsets = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0);
      showTail = true;
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Reply to message
        if (details.primaryVelocity! < 0) {
          // Swiped left, make message do a swipe left animation

        }
      },
      onLongPress: () {
        // Show a menu to do things to message
        // Right now straight up delete the message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).delete_message),
              content: Text(S.of(context).delete_message_confirmation),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    // Checking if its the sender of the message
                    if (message.senderEmail != _auth.currentUser?.email) {
                      // Return a snack bar saying you can't delete other people's messages
                      Navigator.pop(context);
                      return;
                    }
                    msgContext.read<ChatCubit>().deleteMessage(message.messageId, _chatId);
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).delete),
                ),
              ],
            );
          },
        );
      },
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (showSender) Padding(
            padding: edgeInsets,
            child: Text(message.senderEmail.toString() ?? ''),
          ),
          message.content != null ? BubbleSpecialOne(
            isSender: isSender,
            text: message.content ?? '',
            color: color,
            tail: showTail,
          ) : Container(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            child: _buildImageGrid(
                images: message.images,
                edgeInsets:  edgeInsets,
                crossAxisAlignment: crossAxisAlignment,
                mainAxisAlignment: mainAxisAlignment
            ),
          ),
        ],
      ),
    );
  }

  // Make images show up in a grid
  // Images will start from the left and go to the right
  // Images will be shown in a grid of 3 with small size
  Widget _buildImageGrid({
  required List<String?>? images,
  required EdgeInsets edgeInsets,
  required CrossAxisAlignment crossAxisAlignment,
  required MainAxisAlignment mainAxisAlignment,
  }) {
    if (images == null || images.isEmpty) {
      return const SizedBox();
    }
    switch (images.length) {
      case 1:
        return _buildSingleImage(images[0]!, edgeInsets, crossAxisAlignment, mainAxisAlignment);
      default:
        return _buildMultipleImage(images, edgeInsets, crossAxisAlignment, mainAxisAlignment);
    }
  }

  Widget _buildSingleImage(String imageUrl, EdgeInsets edgeInsets, CrossAxisAlignment crossAxisAlignment, MainAxisAlignment mainAxisAlignment) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Container(
          margin: edgeInsets,
          width: MediaQuery
              .of(context)
              .size
              .width / 3,
          child: GestureDetector(
            onTap: () {
              // Show image in full screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImg(imageUrl: imageUrl),
                ),
              );
            },
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleImage(List<String?> images, EdgeInsets edgeInsets, CrossAxisAlignment crossAxisAlignment, MainAxisAlignment mainAxisAlignment) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Container(
          margin: edgeInsets,
          width: MediaQuery
              .of(context)
              .size
              .width / 3,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                int reverseIndex = images.length - 1 - index;
                return GestureDetector(
                  onTap: () {
                    // Show image in full screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullScreenImg(imageUrl: images[reverseIndex]!),
                      ),
                    );
                  },
                  child: Image.network(images[reverseIndex]!, fit: BoxFit.cover),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

