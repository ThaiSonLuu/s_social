import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/features/screen/home/view/comment_screen.dart';
import '../logic/post_cubit.dart';
import 'package:s_social/core/domain/model/post_model.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, List<PostModel>>(
      builder: (context, posts) {
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.postContent ?? 'No content available'),

                  // Kiểm tra nếu có hình ảnh thì hiển thị
                  if (post.postImage != null && post.postImage!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.network(
                        post.postImage ?? '',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text('Image failed to load');
                        },
                      ),
                    ),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentScreen(postId: post.id ?? ''),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
