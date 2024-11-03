import 'dart:core';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
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
  @override
  void initState() {
    context.read<ChatCubit>().getChatSession(_chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String chatId = _chatId;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._recipient?['email']),
        automaticallyImplyLeading: false,
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
        if (state is ChatLoaded) {
          return StreamBuilder(
            stream: context.read<ChatCubit>().getMessages(_chatId),
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
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageItem(messages[index]);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageCtrl,
              decoration: InputDecoration(
                hintText: S.of(context).type_message,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final String content = messageCtrl.text;
              context.read<ChatCubit>().sendMessage(
                  chatId,
                  senderEmail,
                  recipientEmail,
                  content,
              );
              messageCtrl.clear();
            },
          ),
        ],
      ),
    );
  }

  String get _chatId {
    final String currentUserId = _auth.currentUser?.uid ?? '';
    final String recipientId = widget._recipient?['id'] ?? '';
    List<String> userIds = [currentUserId, recipientId];
    userIds.sort();
    return userIds.join('-');
  }

  Widget _buildMessageItem(MessageModel message) {
    Alignment alignment;
    Color color;
    CrossAxisAlignment crossAxisAlignment;
    MainAxisAlignment mainAxisAlignment;
    if (message.senderEmail == _auth.currentUser?.email) {
      alignment = Alignment.centerRight;
      color = Colors.blue[100]!;
      crossAxisAlignment = CrossAxisAlignment.end;
      mainAxisAlignment = MainAxisAlignment.end;
    } else {
      alignment = Alignment.centerLeft;
      color = Colors.grey[200]!;
      crossAxisAlignment = CrossAxisAlignment.start;
      mainAxisAlignment = MainAxisAlignment.start;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Text(message.senderEmail.toString() ?? ''),
            BubbleSpecialThree(
              text: message.content ?? '',
              color: color,
              tail: true,
            ),
          ],
        )
      ),
    );
  }
}

