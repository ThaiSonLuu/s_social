import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/presentation/logic/cubit/app_language/app_language_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/features/screen/home/logic/post_cubit.dart';
import 'package:s_social/features/screen/home/view/post_screen.dart';
import 'package:s_social/features/screen/home/view/widget/full_screen_img.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../generated/l10n.dart';

class PostWidget extends StatelessWidget {
  final PostModel postData;
  final UserModel userData;
  final VoidCallback onTap;

  const PostWidget({
    super.key,
    required this.postData,
    required this.userData,
    required this.onTap,
  });

  Future<ImageInfo> _getImageInfo(String imageUrl) async {
    final Completer<ImageInfo> completer = Completer();
    final ImageStream stream =
        NetworkImage(imageUrl).resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener((ImageInfo info, _) => completer.complete(info)),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    String displayName = postData.postAnonymous == true
        ? S.of(context).anonymous
        : userData.username ?? 'Unknown User';

    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(postData.createdAt!);

    return Card(
      margin: const EdgeInsets.all(0.5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar, username, and post time
          GestureDetector(
            onTap: () {
              context.push("${RouterUri.profile}/${userData.id}");
            },
            child: Padding(
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
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSecondaryFixed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Post content
          if (postData.postContent != null && postData.postContent!.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                postData.postContent!,
                style: const TextStyle(fontSize: 14),
              ),
            ),

          // Post image (if available)
          if (postData.postImage != null && postData.postImage!.isNotEmpty)
            Padding(
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
            ),

          // Post actions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                      onPressed: () {
                        // Logic for liking a post
                      },
                    ),
                    Text('${postData.like} ${S.of(context).like}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {
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
                    Text(S.of(context).comment),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {
                        // Logic for sharing a post
                      },
                    ),
                    Text(S.of(context).share)
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
