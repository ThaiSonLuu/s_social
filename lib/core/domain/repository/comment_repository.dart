import 'package:s_social/core/domain/model/comment_model.dart';

abstract class CommentRepository {
  Future<List<CommentModel>?> getComments(String postId);
  Future<CommentModel?> addComment(CommentModel comment);
  Future<CommentModel?> deleteComment(CommentModel comment);
}
