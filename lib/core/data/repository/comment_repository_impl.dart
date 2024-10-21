import 'package:s_social/core/data/data_source/comment_service.dart';
import 'package:s_social/core/domain/model/comment_model.dart';
import 'package:s_social/core/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl({required CommentDataSource commentDataSource})
      : _commentDataSource = commentDataSource;

  final CommentDataSource _commentDataSource;

  @override
  Future<List<CommentModel>?> getComments(String postId) async {
    try {
      return await _commentDataSource.getComments(postId);
    } catch (_) {
      return null;
    }
  }


  @override
  Future<CommentModel?> addComment(CommentModel cmt) async {
    try {
      return await _commentDataSource.addComment(cmt);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CommentModel?> deleteComment(CommentModel cmt) async {
    try {
      return await _commentDataSource.deleteComment(cmt);
    } catch (_) {
      return null;
    }
  }
}
