import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:s_social/core/domain/model/comment_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/domain/model/post_model.dart';
import 'full_screen_img.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentData;
  final PostModel postData;
  final UserModel userData;

  const CommentWidget({
    Key? key,
    required this.commentData,
    required this.postData,
    required this.userData,
  }) : super(key: key);

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown date';
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _formatDateTime(commentData.createdAt);
    String userName = postData.userId != null
        ? userData.username.toString()
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
              userData.avatarUrl ?? 'https://placehold.co/80x80',
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
                      if (commentData.commentText?.isNotEmpty ?? false)
                        Text(
                          commentData.commentText!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                        ),
                      // Ảnh đính kèm (nếu có)
                      if (commentData.commentImg?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImg(
                                  imageUrl: commentData.commentImg!,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                commentData.commentImg!,
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
                      Text(
                        S.of(context).like,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Phản hồi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          fontWeight: FontWeight.bold,
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
