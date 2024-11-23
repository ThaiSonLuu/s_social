import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/comment_model.dart';
import 'package:s_social/core/domain/repository/comment_repository.dart';
import 'package:s_social/core/domain/repository/upload_file_repository.dart';

import '../../../../core/domain/model/user_model.dart';

class CommentCubit extends Cubit<List<CommentModel>> {
  final CommentRepository commentRepository;
  final UploadFileRepository uploadFileRepository;
  final Map<String, UserModel> userCache = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CommentCubit({
    required this.commentRepository,
    required this.uploadFileRepository,
  }) : super([]);

  Future<void> loadComments(String postId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      final commentsSnapshot = await postRef.collection('comments').get();

      if (commentsSnapshot.docs.isEmpty) {
        emit([]);
      } else {
        final comments = commentsSnapshot.docs
            .map((doc) => CommentModel.fromJson(doc.data()))
            .toList();
        emit(comments);
      }
    } catch (e) {
      print("Error loading comments: $e");
      emit([]);
    }
  }

  Future<void> addComment(CommentModel comment) async {
    await commentRepository.addComment(comment);
    loadComments(comment.postId ?? '');
  }

  Future<void> deleteComment(String commentId, String postId) async {
    await commentRepository.deleteComment(commentId as CommentModel);
    loadComments(postId);
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      final url = uploadFileRepository.postFile(imageFile);
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getUserById(String userId) async {
    if (userCache.containsKey(userId)) {
      return userCache[userId]!;
    } else {
      final user = await fetchUserData(userId);
      userCache[userId] = user;
      return user;
    }
  }

  Future<UserModel> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return UserModel(
          id: userId,
          username: userDoc['username'],
          avatarUrl: userDoc['avatarUrl'],
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print("Error fetching user data: $e");
      throw Exception('Failed to fetch user data');
    }
  }
}
