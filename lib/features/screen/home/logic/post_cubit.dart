import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/repository/post_repository.dart';
import '../../../../core/domain/model/user_model.dart';

class PostCubit extends Cubit<List<PostModel>> {
  final PostRepository postRepository;
  final Map<String, UserModel> userCache = {};

  PostCubit({required this.postRepository}) : super([]);

  Future<void> loadPosts() async {
    try {
      final posts = await postRepository.getPosts();
      if (posts != null) {
        emit(posts);
      } else {
        print("No posts available in repository.");
        emit([]);
      }
    } catch (e) {
      print("Error loading posts: $e");
      emit([]);
    }
  }

  Future<void> createPost(PostModel post) async {
    try {
      await postRepository.createPost(post);
      await loadPosts();
    } catch (e) {
      print("Error creating post: $e");
    }
  }

  Future<void> deletePost(PostModel postId) async {
    try {
      await postRepository.deletePost(postId);
      await loadPosts();
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Task state: ${snapshot.state}');
        print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      print('Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

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
