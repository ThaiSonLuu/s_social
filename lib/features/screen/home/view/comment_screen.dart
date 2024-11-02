import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/comment_model.dart';
import '../logic/comment_cubit.dart';

class CommentScreen extends StatelessWidget {
  final String postId;

  CommentScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit, List<CommentModel>>(
      builder: (context, comments) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(title: Text(comment.commentText ?? ''));
                },
              ),
            ),
            // Form để thêm bình luận mới
          ],
        );
      },
    );
  }
}
