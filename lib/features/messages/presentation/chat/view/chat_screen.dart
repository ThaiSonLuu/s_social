import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/message_model.dart';
import 'package:s_social/di/injection_container.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._recipient?['email']),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ChatCubit>().getChatSession(_chatId);
        },
        child: Column(
          children: [
            _buildChat(),
            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChat() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ChatLoaded) {
          return ListView.builder(
            itemCount: state.chatSession.messages.length,
            itemBuilder: (context, index) {
              final message = state.chatSession.messages[index];
              return ListTile(
                title: Text(message.content.toString()),
              );
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

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageCtrl,
              decoration: const InputDecoration(
                hintText: 'Type a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final String message = messageCtrl.text;
              context.read<ChatCubit>().getChatSession(_chatId);
              context.read<ChatCubit>().sendMessage(
                  _chatId,
                  MessageModel(
                    senderId: _auth.currentUser?.uid,
                    receiverId: widget._recipient?['id'],
                    content: message,
                  ));
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
}

