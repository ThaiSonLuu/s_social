import 'dart:core';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/message_model.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:uuid/uuid.dart';

import '../../../../../generated/l10n.dart';
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
      create: (context) => ChatCubit(chatRepository: serviceLocator()),
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
  @override
  void initState() {
    context.read<ChatCubit>().getChatSession(_chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String chatId = _chatId;
    // Making a back button returning to the previous screen and a menu button that opens sideways
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._recipient?['email']),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ChatLoaded) {
          return StreamBuilder(
            stream: context.read<ChatCubit>().getMessageStream(_chatId),
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
                      showSender: showSender
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
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

  Widget _buildMessageInput() {
    final String chatId = _chatId;
    final String senderEmail = _auth.currentUser?.email ?? '';
    final String recipientEmail = widget._recipient?['email'] ?? '';
    return MessageBar(
      messageBarHintText: S.of(context).type_message,
      onSend: (content) {
        // If the message is empty, don't send
        if (content.isEmpty) {
          return;
        }
        // Send message to the chat session
        context.read<ChatCubit>().sendMessage(
            chatId,
            senderEmail,
            recipientEmail,
            content,
        );
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
            child: const Icon(
              Icons.camera_alt,
              color: Colors.green,
              size: 24,
            ),
            onTap: () {
              // Make ripple effect and open camera (Not implemented)

            },
          ),
        ),
      ],  // Actions
    );
  }

  String get _chatId {
    final String currentUserId = _auth.currentUser?.uid ?? '';
    final String recipientId = widget._recipient?['id'] ?? '';
    List<String> userIds = [currentUserId, recipientId];
    userIds.sort();
    return userIds.join('-');
  }

  Widget _buildMessageItem({required MessageModel message, required bool showSender}) {
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
                    context.read<ChatCubit>().deleteMessage(message.messageId, _chatId);
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
          BubbleSpecialOne(
            isSender: isSender,
            text: message.content ?? '',
            color: color,
            tail: showTail,
          ),
        ],
      ),
    );
  }
}

