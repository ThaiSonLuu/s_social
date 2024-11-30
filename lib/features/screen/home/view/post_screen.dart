import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/comment_model.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/features/screen/home/view/widget/comment_widget.dart';
import '../../../../generated/l10n.dart';
import '../logic/comment_cubit.dart';

class PostScreen extends StatefulWidget {
  final PostModel postData;
  final UserModel? postUserData;

  const PostScreen({
    super.key,
    required this.postData,
    required this.postUserData,
  });

  @override
  State<StatefulWidget> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommentCubit>().loadComments(widget.postData.id!);
  }

  @override
  Widget build(BuildContext context) {
    String? userPostName = widget.postData.userId == null
        ? S.of(context).anonymous
        : widget.postUserData?.username;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          final double appBarHeight = kToolbarHeight;
          final double inputFieldHeight = 60.0;
          final double contentHeight =
              screenHeight - appBarHeight - inputFieldHeight;

          return Column(
            children: [
              AppBar(
                title: Text('Bài viết của $userPostName'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: contentHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PostSection(
                          postData: widget.postData,
                          userData: widget.postUserData,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            S.of(context).comment,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        BlocBuilder<CommentCubit, List<CommentModel>>(
                          builder: (context, comments) {
                            if (comments.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(S.of(context).no_comment_yet),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                return FutureBuilder<UserModel>(
                                  future: context
                                      .read<CommentCubit>()
                                      .getUserById(comment.userId!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                          child: Text('Error fetching user.'));
                                    } else if (!snapshot.hasData) {
                                      return const Center(
                                          child: Text('User not found.'));
                                    }

                                    final userComment = snapshot.data!;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: CommentWidget(
                                        commentData: comment,
                                        postData: widget.postData,
                                        userData: userComment,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SizedBox(
                  height: inputFieldHeight,
                  child: _CommentInputField(
                    postId: widget.postData.id!,
                    userId: FirebaseAuth.instance.currentUser?.uid ?? "",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PostSection extends StatelessWidget {
  final PostModel postData;
  final UserModel? userData;

  const _PostSection({
    required this.postData,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(postData.postContent ?? ""),
          ),
          if (postData.postImage != null && postData.postImage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                postData.postImage!,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${postData.like} ${S.of(context).like}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInputField extends StatefulWidget {
  final String postId;
  final String userId;

  const _CommentInputField({
    required this.postId,
    required this.userId,
  });

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<_CommentInputField> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: S.of(context).write_comment,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              String? imgUrl;
              if (_contentController.text.isNotEmpty) {
                final postRef = FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.postId);
                final commentRef = postRef.collection('comments').doc();

                final newComment = CommentModel(
                  id: commentRef.id,
                  postId: widget.postId,
                  userId: widget.userId,
                  commentText: _contentController.text.trim(),
                  commentImg: imgUrl,
                  createdAt: DateTime.now(),
                );

                await commentRef.set(newComment.toJson());
                context.read<CommentCubit>().loadComments(widget.postId);
                _contentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
