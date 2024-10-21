import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/repository/post_repository.dart';

class PostCubit extends Cubit<List<PostModel>> {
  final PostRepository postRepository;

  PostCubit({required this.postRepository}) : super([]);

  Future<void> loadPosts() async {
    final posts = await postRepository.getPosts();
    emit(posts ?? []);
  }

  // Future<void> createPost(PostModel post) async {
  //   await postRepository.createPost(post);
  //   loadPosts();
  // }

  Future<void> createPost(PostModel post) async {
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'id': post.id,
        'userId': post.userId,
        'postContent': post.postContent,
        'postImage': post.postImage, // Lưu URL ảnh ở đây
        'createdAt': post.createdAt?.toIso8601String(),
        'comments': post.comments, // có thể là mảng rỗng hoặc null
        'like': post.like,
      });
      loadPosts(); // Sau khi thêm, load lại danh sách post
    } catch (e) {
      print('Error saving post: $e');
    }
  }


  Future<void> deletePost(PostModel postId) async {
    await postRepository.deletePost(postId);
    loadPosts();
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


}
