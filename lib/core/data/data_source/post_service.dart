import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/common/app_constants/firestore_collection_constants.dart';
import 'package:s_social/core/domain/model/post_model.dart';

class PostDataSource {
  CollectionReference get _postsCollection {
    final firestoreDatabase = FirebaseFirestore.instance;
    return firestoreDatabase.collection(FirestoreCollectionConstants.posts);
  }

  Future<List<PostModel>> getPosts({String? userId}) async {
    try {
      QuerySnapshot snapshot;
      if (userId != null) {
        snapshot = await _postsCollection
            .where('userId', isEqualTo: userId)
            .orderBy(
              "createdAt",
              descending: true,
            )
            .get();
      } else {
        snapshot = await _postsCollection
            .orderBy(
              "createdAt",
              descending: true,
            )
            .get();
      }

      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<PostModel> createPost(PostModel post) async {
    try {
      DocumentReference<dynamic> postDoc = _postsCollection.doc(post.id);
      final savePost = post.copyWith(id: postDoc.id);
      await postDoc.set(savePost.toJson());
      return savePost;
    } catch (_) {
      rethrow;
    }
  }

  Future<PostModel> deletePost(PostModel post) async {
    try {
      DocumentReference<dynamic> postDoc = _postsCollection.doc(post.id);
      await postDoc.delete();
      return post;
    } catch (_) {
      rethrow;
    }
  }
}
