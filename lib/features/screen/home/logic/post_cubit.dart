import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/repository/post_repository.dart';
import 'package:s_social/core/domain/repository/upload_file_repository.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';
import 'package:s_social/features/screen/home/logic/post_state.dart';

import '../../../../core/domain/model/user_model.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;
  final UploadFileRepository uploadFileRepository;
  final UserRepository userRepository;

  PostCubit({
    required this.postRepository,
    required this.uploadFileRepository,
    required this.userRepository,
  }) : super(PostInitial());

  Future<void> loadPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepository.getPosts();
      await Future.delayed(const Duration(seconds: 1));
      emit(PostLoaded(posts ?? []));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> createPost(PostModel post) async {
    try {
      await postRepository.createPost(post);
      await loadPosts();
    } catch (_) {}
  }

  Future<void> deletePost(PostModel postId) async {
    try {
      await postRepository.deletePost(postId);
      await loadPosts();
    } catch (_) {}
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      final url = uploadFileRepository.postFile(imageFile);
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      return await userRepository.getUserById(userId);
    } catch (_) {
      return null;
    }
  }
}
