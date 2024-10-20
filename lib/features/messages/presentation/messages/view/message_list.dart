import 'package:flutter/material.dart';
import 'package:s_social/features/auth/presentation/login/logic/login_cubit.dart';
import 'package:s_social/features/messages/presentation/messages/view/user_tile.dart';

import '../logic/chat_service.dart';
import 'chat_screen.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MessageList();
  }
}

class _MessageList extends StatefulWidget {
  const _MessageList();

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  final ChatService _chatService = ChatService();
  final LoginCubit _authService = LoginCubit(userRepository: userRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
        automaticallyImplyLeading: false,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        // Error
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Return list of users
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(
            userData,
            context,
          )).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    // Display all users except the current user
    return UserTile(
      text: userData["email"],
      // On tap, navigate to chat screen
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
          recipientEmail: userData["email"],
        )));
      }
    );
  }
}
