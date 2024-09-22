import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _controller = TextEditingController();

  void _post() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('posts').add({
        'text': _controller.text,
        'author': user.displayName,
        'createdAt': Timestamp.now(),
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _post,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Write something...'),
        ),
      ),
    );
  }
}
