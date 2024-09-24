import 'package:flutter/material.dart';
import 'package:s_social/features/screen/home/model/post_data.dart';

import 'comment_screen.dart';

class PostScreen extends StatelessWidget {
  final int postId;

  PostScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    final PostData data = PostData(
      userName: '$postId',
        userImg: 'userImg',
        content: 'content',
        postImg: 'postImg',
        like: 1,
        cmtNo: 1,
        share: 1,
    );


    return Scaffold(
      appBar: AppBar(
        title: Text('Post $postId'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Post content for post $postId'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CommentScreen(
                          postId: postId,
                          data: data,),
                  ),
                );
              },
              child: Text('View Comments'),
            ),
          ],
        ),
      ),
    );
  }
}
