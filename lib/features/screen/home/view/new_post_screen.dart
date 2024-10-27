import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/generated/l10n.dart';
import '../../../../core/domain/model/post_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../logic/post_cubit.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  bool postAnonymous = false;
  String? username;
  String? userId;
  File? _selectedImg;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImg = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImg = File(pickedFile.path);
      });
    }
  }

  Future<void> _recordVoiceMessage() async {
    // Logic for recording voice message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<ProfileUserCubit, ProfileUserState>(
                builder: (context, state) {
                  if (state is ProfileUserLoaded) {
                    username = postAnonymous ? S.of(context).anonymous : state.user.username;
                    userId = state.user.id;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Posting as: $username'),
                      Switch(
                        value: postAnonymous,
                        onChanged: (value) {
                          setState(() {
                            postAnonymous = value;
                            username = value ? S.of(context).anonymous : username;
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: S.of(context).new_post,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              if (_selectedImg != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(
                    _selectedImg!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library_outlined),
                    onPressed: _pickImageFromGallery,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: _takePhoto,
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic_none),
                    onPressed: _recordVoiceMessage,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String? imgUrl;

                  if (_selectedImg != null) {
                    print('Selected image path: ${_selectedImg!.path}');
                    imgUrl = await context.read<PostCubit>().uploadImageToFirebase(_selectedImg!);
                  }

                  DocumentReference docRef = FirebaseFirestore.instance.collection('posts').doc();
                  final newPost = PostModel(
                    id: docRef.id,
                    userId: userId,
                    postContent: _contentController.text,
                    // postImage: _selectedImg != null ? _selectedImg!.path : null,
                    postImage: imgUrl,
                    createdAt: DateTime.now(),
                    comments: [],
                    like: 0,
                  );
                  await context.read<PostCubit>().createPost(newPost);
                  Navigator.pop(context, newPost);
                },
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
