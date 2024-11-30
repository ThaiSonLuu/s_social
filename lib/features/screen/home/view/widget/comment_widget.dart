import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:s_social/core/domain/model/comment_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import '../../../../../core/domain/model/reaction_model.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/domain/model/post_model.dart';
import '../../logic/reaction_cubit.dart';
import 'full_screen_img.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel commentData;
  final PostModel postData;
  final UserModel userData;

  const CommentWidget({
    Key? key,
    required this.commentData,
    required this.postData,
    required this.userData,
  }) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}


class _CommentWidgetState extends State<CommentWidget> {
  bool isReact = false;
  int reactCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchReactStatus();
    _fetchReactCount();
  }

  void _fetchReactStatus() async {
    final reactionCubit = context.read<ReactionCubit>();
    bool reacted = await reactionCubit.checkUserReacted(
      widget.commentData.id!,
      'comments',
      'like',
    );
    if (mounted) {
      setState(() {
        isReact = reacted;
      });
    }
  }

  void _fetchReactCount() async {
    final reactionCubit = context.read<ReactionCubit>();
    reactionCubit.countReactions(
      widget.commentData.id!,
      'comments',
    ).listen((count) {
      if (mounted) {
        setState(() {
          reactCount = count;
        });
      }
    });
  }

  void _toggleReact() {
    final reactionCubit = context.read<ReactionCubit>();
    reactionCubit.toggleReaction(
      ReactionModel(
        userId: widget.userData.id,
        targetId: widget.commentData.id,
        targetType: 'comments',
        reactionType: 'like',
        isReaction: !isReact,
        updateTime: DateTime.now(),
      ),
    );

    setState(() {
      isReact = !isReact;
    });
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown date';
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _formatDateTime(widget.commentData.createdAt);
    String userName = widget.postData.userId != null
        ? widget.userData.username.toString()
        : S.of(context).anonymous;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              widget.userData.avatarUrl ?? 'https://placehold.co/80x80',
            ),
          ),
          const SizedBox(width: 8),

          // Nội dung comment
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container chứa nội dung comment
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên người dùng
                      Text(
                        // postData.userId == userData.id ? userData.username! : S.of(context).anonymous,
                        userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Nội dung văn bản comment
                      if (widget.commentData.commentText?.isNotEmpty ?? false)
                        Text(
                          widget.commentData.commentText!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                        ),
                      // Ảnh đính kèm (nếu có)
                      if (widget.commentData.commentImg?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImg(
                                  imageUrl: widget.commentData.commentImg!,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.commentData.commentImg!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Text('Image failed to load'),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Hành động (ngày giờ, thích, phản hồi)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _toggleReact,
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            Text(
                              '$reactCount ' + S.of(context).like,
                              style: TextStyle(
                                fontSize: 12,
                                color: isReact ? Colors.blue : Theme.of(context).colorScheme.onPrimaryFixed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Nút thêm tùy chọn
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              size: 20,
              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),
            onPressed: () {
              // Menu tùy chọn
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                      title: const Text('Chỉnh sửa bình luận'),
                      onTap: () {
                        Navigator.pop(context);
                        // Logic chỉnh sửa
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
