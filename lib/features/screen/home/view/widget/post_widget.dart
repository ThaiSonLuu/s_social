import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/core/utils/shimmer_loading.dart';
import 'package:s_social/core/utils/ui/cache_image.dart';
import 'package:s_social/features/screen/home/view/post_screen.dart';
import 'package:s_social/features/screen/home/view/widget/full_screen_img.dart';
import 'package:s_social/gen/assets.gen.dart';
import 'package:s_social/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/domain/model/reaction_model.dart';
import '../../logic/reaction_cubit.dart';

class PostWidget extends StatefulWidget {
  final PostModel postData;
  final UserModel? userData;

  const PostWidget({
    super.key,
    required this.postData,
    required this.userData,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}


class _PostWidgetState extends State<PostWidget> {
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
      widget.postData.id!,
      'posts',
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
      widget.postData.id!,
      'posts',
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
        userId: widget.userData?.id,
        targetId: widget.postData.id,
        targetType: 'posts',
        reactionType: 'like',
        isReaction: !isReact,
        updateTime: DateTime.now(),
      ),
    );

    setState(() {
      isReact = !isReact;
    });
  }

  void _sharePost() {
    final String? postContent = widget.postData.postContent;
    final String? postImage = widget.postData.postImage;

    // Nếu không có nội dung hoặc ảnh, hiển thị thông báo lỗi
    if ((postContent == null || postContent.isEmpty) &&
        (postImage == null || postImage.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No Post")),
      );
      return;
    }
    String shareUrl = "https://s0social.page.link/post?id=${widget.postData.id}";
    String shareMessage = "Truy cập vào mạng xã hội S_social tại đây: $shareUrl";
    Share.share(shareMessage, subject: "Chia sẻ bài viết từ S_social");
  }


  @override
  Widget build(BuildContext context) {
    String displayName = widget.postData.userId != null
        ? (widget.userData?.username).toString()
        : S.of(context).anonymous;

    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(widget.postData.createdAt!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar, username, and post time
        GestureDetector(
          onTap: () {
            if (widget.userData != null) {
              context.push("${RouterUri.profile}/${widget.userData!.id}");
            }
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
          _buildPostUserAvatar(),
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

  Widget _buildPostUserAvatar() {
    if (widget.postData.userId == null) {
      return Container(
        width: 40,
        height: 40,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.lightBlue,
        ),
        child: Image.asset(Assets.images.anonymous.path),
      );
    }

    if ((widget.userData?.avatarUrl ?? "").isNotEmpty) {
      return Container(
        width: 40,
        height: 40,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CacheImage(
          imageUrl: widget.userData?.avatarUrl ?? "",
          loadingWidth: 40,
          loadingHeight: 40,
        ),
      );
    }
    return Container(
      width: 40,
      height: 40,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: TextToImage(
        text: (widget.userData?.username).toString()[0],
        textSize: 16.0,
      ),
    );
  }

  Widget _buildPostMessage() {
    if (widget.postData.postContent != null && widget.postData.postContent!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          widget.postData.postContent!,
          style: const TextStyle(fontSize: 14),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPostImage({
    required BuildContext context,
  }) {
    if (widget.postData.postImage != null && widget.postData.postImage!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FullScreenImg(imageUrl: widget.postData.postImage!),
              ),
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CacheImage(
                imageUrl: widget.postData.postImage ?? "",
                loadingWidth: constraints.maxWidth,
                loadingHeight: constraints.maxWidth * 0.6,
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
          icon: isReact ? Icons.thumb_up : Icons.thumb_up_outlined,
          label: "$reactCount ${S.of(context).like}",
          color: isReact ? Colors.blue : Theme.of(context).colorScheme.onPrimaryFixed,
          onTap: _toggleReact,
        ),
        _buildPostItem(
          icon: Icons.comment_outlined,
          label: S.of(context).comment,
          color: Theme.of(context).colorScheme.onPrimaryFixed,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostScreen(
                  postData: widget.postData,
                  postUserData: widget.userData,
                ),
              ),
            );
          },
        ),
        _buildPostItem(
          icon: Icons.share_outlined,
          label: S.of(context).share,
          color: Theme.of(context).colorScheme.onPrimaryFixed,
          onTap: _sharePost,
        ),
      ],
    );
  }

  Widget _buildPostItem({
    required IconData icon,
    required String label,
    required Color color,
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
                Icon(icon, color: color,),
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
