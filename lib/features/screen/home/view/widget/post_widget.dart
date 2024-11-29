import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/core/utils/shimmer_loading.dart';
import 'package:s_social/features/screen/home/view/post_screen.dart';
import 'package:s_social/features/screen/home/view/widget/full_screen_img.dart';
import 'package:s_social/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

class PostWidget extends StatelessWidget {
  final PostModel postData;
  final UserModel userData;

  const PostWidget({
    super.key,
    required this.postData,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    String displayName = postData.postAnonymous == true
        ? S.of(context).anonymous
        : userData.username ?? 'Unknown User';

    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(postData.createdAt!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar, username, and post time
        GestureDetector(
          onTap: () {
            context.push("${RouterUri.profile}/${userData.id}");
          },
          child: _buildPostHeader(
            context: context,
            displayName: displayName,
            datetime: formattedDate,
          ),
        ),
        _buildPostMessage(),
        _buildPostImage(context: context),
        _buildPostAction(context: context),
      ],
    );
  }

  Widget _buildPostHeader({
    required BuildContext context,
    required String displayName,
    required String datetime,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userData.avatarUrl != null
              ? CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    userData.avatarUrl!,
                  ),
                  onBackgroundImageError: (error, stackTrace) {
                    // Handle error when loading avatar
                  },
                )
              : Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: TextToImage(
                    text: userData.username.toString()[0],
                    textSize: 16.0,
                  ),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  datetime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSecondaryFixed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostMessage() {
    if (postData.postContent != null && postData.postContent!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          postData.postContent!,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPostImage({
    required BuildContext context,
  }) {
    if (postData.postImage != null && postData.postImage!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FullScreenImg(imageUrl: postData.postImage!),
              ),
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Image.network(
                postData.postImage ?? "",
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    // When the image is fully loaded
                    return child;
                  } else {
                    // Show shimmer background during loading
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade400,
                      child: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth * 0.6,
                        color: Colors.white,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  // Show a fallback UI for errors
                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth * 0.6,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.refresh, size: 48),
                  );
                },
              );
            },
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPostAction({
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildPostItem(
          icon: Icons.thumb_up_alt_outlined,
          label: "${postData.like} ${S.of(context).like}",
          onTap: () {},
        ),
        _buildPostItem(
          icon: Icons.comment_outlined,
          label: S.of(context).comment,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostScreen(
                  postData: postData,
                  postUserData: userData,
                ),
              ),
            );
          },
        ),
        _buildPostItem(
          icon: Icons.share_outlined,
          label: S.of(context).share,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPostItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                const SizedBox(width: 6.0),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerPost extends StatelessWidget {
  const ShimmerPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostHeader(),
        _buildPostMessage(),
        _buildPostImage(),
        _buildPostAction(),
      ],
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade400,
            child: Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  width: 70,
                  height: 16,
                ),
                SizedBox(height: 4),
                ShimmerLoading(
                  width: 50,
                  height: 14,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoading(
            width: 200,
            height: 18,
          ),
          SizedBox(height: 2.0),
          ShimmerLoading(
            width: 240,
            height: 18,
          ),
          SizedBox(height: 2.0),
          ShimmerLoading(
            width: 220,
            height: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ShimmerLoading(
        width: double.maxFinite,
        height: 300,
      ),
    );
  }

  Widget _buildPostAction() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildActionItem(),
        _buildActionItem(),
        _buildActionItem(),
      ],
    );
  }

  Widget _buildActionItem() {
    return const Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ShimmerLoading(
          width: 50,
          height: 30,
          borderRadius: 8.0,
        ),
      ),
    );
  }
}
