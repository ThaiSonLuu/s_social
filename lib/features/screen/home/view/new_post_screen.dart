import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/utils/ui/dialog_loading.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/screen/home/logic/post_cubit.dart';
import 'package:s_social/generated/l10n.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostCubit(
            postRepository: serviceLocator(),
            uploadFileRepository: serviceLocator(),
            userRepository: serviceLocator(),
          ),
        ),
      ],
      child: const _NewPostScreen(),
    );
  }
}

class _NewPostScreen extends StatefulWidget {
  const _NewPostScreen();

  @override
  State<StatefulWidget> createState() => _NewPostState();
}

class _NewPostState extends State<_NewPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  bool postAnonymous = false;
  String? username;
  String? userId;
  File? _selectedImg;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImg = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
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
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(S.of(context).new_post),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<ProfileUserCubit, ProfileUserState>(
                builder: (context, state) {
                  if (state is ProfileUserLoaded) {
                    username = postAnonymous
                        ? S.of(context).anonymous
                        : state.user.username;
                    userId = state.user.id;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${S.of(context).post_by}: $username'),
                      Switch(
                        value: postAnonymous,
                        onChanged: (value) {
                          setState(() {
                            postAnonymous = value;
                            username =
                                value ? S.of(context).anonymous : username;
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
                  labelText: S.of(context).new_post_box,
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
                  final shouldReload = await context.showDialogLoading<bool>(
                    future: () async {
                      final result = await context.read<PostCubit>().createPost(
                            postAnonymous ? null : userId,
                            _contentController.text,
                            _selectedImg,
                          );
                      return result != null;
                    },
                  );

                  if (context.mounted) {
                    context.pop(shouldReload);
                  }
                },
                child: Text(S.of(context).post),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
