import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/comment_model.dart';
import 'package:s_social/core/domain/repository/comment_repository.dart';

class CommentCubit extends Cubit<List<CommentModel>> {
  final CommentRepository commentRepository;

  CommentCubit(this.commentRepository) : super([]);

  Future<void> loadComments(String postId) async {
    final comments = await commentRepository.getComments(postId);
    emit(comments ?? []);
  }

  Future<void> addComment(CommentModel comment) async {
    await commentRepository.addComment(comment);
    loadComments(comment.postId ?? '');
  }

  Future<void> deleteComment(String commentId, String postId) async {
    await commentRepository.deleteComment(commentId as CommentModel);
    loadComments(postId);
  }
}
