import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/common/app_constants/firestore_collection_constants.dart';
import 'package:s_social/core/domain/model/comment_model.dart';

class CommentDataSource {
  CollectionReference get _commentsCollection {
    final firestoreDatabase = FirebaseFirestore.instance;
    return firestoreDatabase.collection(FirestoreCollectionConstants.comments);
  }

  Future<List<CommentModel>> getComments(String postId) async {
    try {
      QuerySnapshot snapshot =
          await _commentsCollection.where('postId', isEqualTo: postId).get();

      return snapshot.docs.map((doc) {
        return CommentModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<CommentModel> addComment(CommentModel comment) async {
    try {
      DocumentReference commentDoc = _commentsCollection.doc(comment.id);
      final saveComment = comment.copyWith(id: commentDoc.id);
      await commentDoc.set(saveComment.toJson());
      return saveComment;
    } catch (_) {
      rethrow;
    }
  }

  Future<CommentModel> deleteComment(CommentModel comment) async {
    try {
      DocumentReference commentDoc = _commentsCollection.doc(comment.id);
      await commentDoc.delete();
      return comment;
    } catch (_) {
      rethrow;
    }
  }
}
