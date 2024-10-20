import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String recipientEmail;
  const ChatScreen({
    super.key,
    required this.recipientEmail
  });

  @override
  Widget build(BuildContext context) {
    return const _ChatScreen();
  }
}

class _ChatScreen extends StatefulWidget {
  const _ChatScreen();

  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        automaticallyImplyLeading: false,
      ),
      body: const Scaffold(

      ),
    );
  }
}

