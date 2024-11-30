import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/domain/model/friend_model.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/core/utils/extensions/is_current_user.dart';
import 'package:s_social/core/utils/shimmer_loading.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/friends/presentation/logic/count_friend_cubit.dart';
import 'package:s_social/features/friends/presentation/logic/friend_cubit.dart';
import 'package:s_social/features/screen/home/logic/post_cubit.dart';
import 'package:s_social/features/screen/home/logic/post_state.dart';
import 'package:s_social/features/screen/home/view/widget/post_widget.dart';
import 'package:s_social/features/user_profile/presentation/user_profile/logic/s_user_profile_cubit.dart';
import 'package:s_social/gen/assets.gen.dart';
import 'package:s_social/generated/l10n.dart';

class SUserProfileScreen extends StatelessWidget {
  const SUserProfileScreen({
    super.key,
    required this.uid,
  });

  final String? uid;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SUserProfileCubit(
            userRepository: serviceLocator(),
            uid: uid,
          )..getUserInfoByUid(),
        ),
        BlocProvider(
          create: (context) {
            return CountFriendCubit(
              serviceLocator(),
              uid,
            )..fetchFriendsCount();
          },
        ),
        BlocProvider(
          create: (context) => GetFriendCubit(
            serviceLocator(),
            serviceLocator(),
            uid ?? "",
          )..getFriendStatusWithUser(),
        ),
        BlocProvider(
          create: (context) => PostCubit(
            postRepository: serviceLocator(),
            uploadFileRepository: serviceLocator(),
            userRepository: serviceLocator(),
          )..loadPosts(userId: uid),
        ),
      ],
      child: _UserProfileScreen(uid),
    );
  }
}

class _UserProfileScreen extends StatelessWidget {
  const _UserProfileScreen(this.uid);

  final String? uid;

  Future<void> refreshAll(BuildContext context) async {
    context.read<SUserProfileCubit>().getUserInfoByUid();
    context.read<CountFriendCubit>().fetchFriendsCount();
    context.read<GetFriendCubit>().getFriendStatusWithUser();
    context.read<PostCubit>().loadPosts(userId: uid);
  }

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundImages = [
      Assets.images.backgroundDefault1,
      Assets.images.backgroundDefault2,
      Assets.images.backgroundDefault3,
      Assets.images.backgroundDefault4,
      Assets.images.backgroundDefault5,
      Assets.images.backgroundDefault6,
      Assets.images.backgroundDefault7,
      Assets.images.backgroundDefault8,
      Assets.images.backgroundDefault9,
      Assets.images.backgroundDefault10,
    ];

    final randomInt = Random().nextInt(10);
    final randomBackground = defaultBackgroundImages[randomInt];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshAll(context);
        },
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _buildContent(
              context: context,
              randomBackground: randomBackground,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required AssetGenImage randomBackground,
  }) {
    return BlocBuilder<SUserProfileCubit, SUserProfileState>(
      builder: (context, state) {
        if (state is SUserProfileLoading) {
          return UserProfileShimmer(
            uid: uid ?? "",
          );
        }

        String? avatarUrl;
        String? backgroundUrl;
        String? username;
        String? email;
        String? bio;

        if (state is SUserProfileLoaded) {
          backgroundUrl = state.user.backgroundUrl;
          avatarUrl = state.user.avatarUrl;
          username = state.user.username;
          email = state.user.email;
          bio = state.user.bio;
        }

        return Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: _buildBackgroundImage(
                    context: context,
                    isLoading: state is SUserProfileLoading,
                    randomBackground: randomBackground,
                    backgroundUrl: backgroundUrl,
                  ),
                ),
                Positioned(
                  left: 20.0,
                  bottom: 0.0,
                  child: _buildAvatarImage(
                    context: context,
                    isLoading: state is SUserProfileLoading,
                    avatarUrl: avatarUrl,
                    username: username,
                  ),
                ),
                Positioned(
                  top: 12.0,
                  left: 12.0,
                  child: _buildBackIcon(context),
                ),
                if (isCurrentUser(uid ?? ""))
                  Positioned(
                    top: 12.0,
                    right: 12.0,
                    child: _buildEditButton(context),
                  ),
              ],
            ),
            _buildNameView(
              context: context,
              username: username,
              email: email,
              bio: bio,
            ),
            const SizedBox(height: 16.0),
            _buildFriendsView(context),
            _buildPostsView(),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundImage({
    required BuildContext context,
    required bool isLoading,
    required AssetGenImage randomBackground,
    String? backgroundUrl,
  }) {
    return SizedBox(
      width: double.maxFinite,
      child: AspectRatio(
        aspectRatio: 2.2,
        child: isLoading
            ? Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
              )
            : Image.network(
                backgroundUrl ?? "",
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  return Container(
                    width: 110,
                    height: 110,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: child,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    width: 110,
                    height: 110,
                    child: Image.asset(
                      randomBackground.path,
                      fit: BoxFit.fill,
                    ),
                  );
                },
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
              ),
      ),
    );
  }

  Widget _buildAvatarImage({
    required BuildContext context,
    required bool isLoading,
    String? avatarUrl,
    String? username,
  }) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: isLoading
            ? Container(
                width: 110,
                height: 110,
                color: Theme.of(context).colorScheme.surfaceContainer,
              )
            : Image.network(
                avatarUrl ?? "",
                fit: BoxFit.cover,
                width: 110,
                height: 110,
                loadingBuilder: (context, child, loadingProgress) {
                  return Container(
                    width: 110,
                    height: 110,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: child,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    width: 110,
                    height: 110,
                    child: TextToImage(
                      text: username?[0].toUpperCase() ?? "S",
                      textSize: 48,
                    ),
                  );
                },
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
              ),
      ),
    );
  }

  Widget _buildBackIcon(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.6),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final shouldReload =
            await context.push<bool>("${RouterUri.editProfile}/$uid");
        if (shouldReload == true && context.mounted) {
          context.read<SUserProfileCubit>().getUserInfoByUid();
        }
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color:
              Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(S.of(context).edit),
        ),
      ),
    );
  }

  Widget _buildNameView({
    required BuildContext context,
    String? username,
    String? email,
    String? bio,
  }) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              username == null
                  ? Container(
                      width: 130,
                      height: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    )
                  : Text(
                      username,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
              const SizedBox(width: 10),
              if (!isCurrentUser(uid ?? ""))
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Increased radius
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0, // Smaller button padding
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  child: Text(
                    S.of(context).send_message,
                    style: const TextStyle(
                      fontSize: 10.0, // Smaller text size
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 6.0),
          email == null
              ? Container(
                  width: 220,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                )
              : Text(email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
          if ((bio ?? "").isNotEmpty) ...[
            const SizedBox(height: 12.0),
            Text(bio!),
          ],
        ],
      ),
    );
  }

  Widget _buildFriendsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocBuilder<CountFriendCubit, CountFriendState>(
        builder: (context, state) {
          if (state is CountFriendLoaded) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      S.of(context).friends,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                        "${state.friendsCount} ${S.of(context).friends.toLowerCase()}"),
                  ],
                ),
                if (!isCurrentUser(uid ?? ""))
                  _buildFriendView(currentUid, uid ?? "")
              ],
            );
          }

          return const SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(width: 70, height: 20),
                SizedBox(height: 2),
                ShimmerLoading(width: 65, height: 18),
              ],
            ),
          ); // Default empty state
        },
      ),
    );
  }

  Widget _buildFriendView(String currentUid, String uid) {
    return BlocConsumer<GetFriendCubit, GetFriendState>(
      listener: (context, state) {
        if (state is FriendDoneAction) {
          context.read<GetFriendCubit>().sendNotification(
              action: state.action,
              currentUser: context.read<ProfileUserCubit>().currentUser,
              targetUser: context.read<ProfileUserCubit>().currentUser);
        }
      },
      builder: (context, state) {
        if (state is FriendLoading) {
          // Show a loading indicator while processing
          return SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        if (state is FriendLoaded) {
          final friendStatus = state.friendStatus.status;

          switch (friendStatus) {
            case FriendStatus.notExist:
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Increased radius
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0, // Smaller button padding
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  context.read<GetFriendCubit>().sendFriendRequest(
                        senderId: currentUid,
                        receiverId: uid,
                      );
                },
                child: Text(
                  S.of(context).send_request,
                  style: const TextStyle(
                    fontSize: 10.0, // Smaller text size
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );

            case FriendStatus.waiting:
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  context
                      .read<GetFriendCubit>()
                      .declineFriendRequest(state.friendStatus.id);
                },
                child: Text(
                  S.of(context).cancel_request,
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );

            case FriendStatus.needResponse:
              // Show Accept and Decline buttons
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      // Green for Accept
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      context
                          .read<GetFriendCubit>()
                          .acceptFriendRequest(state.friendStatus.id);
                    },
                    child: Text(
                      S.of(context).accept,
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4), // Smaller spacing
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      // Red for Decline
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      context
                          .read<GetFriendCubit>()
                          .declineFriendRequest(state.friendStatus.id);
                    },
                    child: Text(
                      S.of(context).decline,
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );

            case FriendStatus.friend:
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  context
                      .read<GetFriendCubit>()
                      .declineFriendRequest(state.friendStatus.id);
                },
                child: Text(
                  S.of(context).unfriend,
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );

            default:
              return const SizedBox.shrink();
          }
        }

        // Default state (FriendInitial or unhandled states)
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPostsView() {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        List<ShowPost> showPosts = [];
        bool isLoading = false;
        bool isError = false;

        if (state is PostLoading) {
          isLoading = true;
        }

        if (state is PostLoaded) {
          showPosts = state.posts;
        }

        if (state is PostError) {
          isError = true;
        }

        showPosts
            .sort((a, b) => b.post.createdAt!.compareTo(a.post.createdAt!));

        return ListView.separated(
          itemCount: showPosts.length + 1,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (isLoading) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  ShimmerPost(),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  ShimmerPost(),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  ShimmerPost(),
                ],
              );
            }

            if (isError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: 500.0,
                    child: Center(
                      child: Text(
                        S.of(context).an_error_occur,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }

            if (showPosts.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 500.0,
                    child: Center(
                      child: Text(S.of(context).no_post_available),
                    ),
                  ),
                ],
              );
            }

            if (index == 0) {
              return const SizedBox.shrink();
            }

            final showPost = showPosts[index - 1];

            return PostWidget(
              postData: showPost.post,
              userData: showPost.user,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.grey,
              thickness: 0.5,
            );
          },
        );
      },
    );
  }
}

class UserProfileShimmer extends StatelessWidget {
  const UserProfileShimmer({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: _buildBackgroundImage(),
            ),
            Positioned(
              top: 12.0,
              left: 12.0,
              child: _buildBackIcon(context),
            ),
            if (isCurrentUser(uid))
              Positioned(
                top: 12.0,
                right: 12.0,
                child: _buildEditButton(context),
              ),
            Positioned(
              left: 20.0,
              bottom: 0.0,
              child: _buildAvatarImage(context),
            ),
          ],
        ),
        _buildNameView(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading(width: 70, height: 20),
                  SizedBox(
                    height: 2,
                  ),
                  ShimmerLoading(width: 65, height: 18),
                ],
              ),
              if (!isCurrentUser(uid)) _buildFriendView(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
        ),
        const ShimmerPost(),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
        ),
        const ShimmerPost(),
        const Divider(
          color: Colors.grey,
          thickness: 0.5,
        ),
        const ShimmerPost(),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return const SizedBox(
      width: double.maxFinite,
      child: AspectRatio(
        aspectRatio: 2.2,
        child: ShimmerLoading(
          width: double.maxFinite,
          height: double.maxFinite,
        ),
      ),
    );
  }

  Widget _buildAvatarImage(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: const ShimmerLoading(
          width: 110,
          height: 110,
        ),
      ),
    );
  }

  Widget _buildBackIcon(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.6),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final shouldReload =
            await context.push<bool>("${RouterUri.editProfile}/$uid");
        if (shouldReload == true && context.mounted) {
          context.read<SUserProfileCubit>().getUserInfoByUid();
        }
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color:
              Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(S.of(context).edit),
        ),
      ),
    );
  }

  Widget _buildNameView() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerLoading(width: 130, height: 26),
          SizedBox(height: 6.0),
          ShimmerLoading(width: 220, height: 20),
          SizedBox(height: 12.0),
          ShimmerLoading(width: 200, height: 16),
          SizedBox(height: 4.0),
          ShimmerLoading(width: 240, height: 16),
          SizedBox(height: 4.0),
          ShimmerLoading(width: 220, height: 16),
        ],
      ),
    );
  }

  Widget _buildFriendView() {
    return const ShimmerLoading(
      width: 80,
      height: 24,
      borderRadius: 20,
    );
  }
}
