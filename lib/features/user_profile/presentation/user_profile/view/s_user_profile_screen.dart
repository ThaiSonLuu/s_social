import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/domain/model/friend_model.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/core/utils/extensions/is_current_user.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/friends/presentation/logic/count_friend_cubit.dart';
import 'package:s_social/features/friends/presentation/logic/friend_cubit.dart';
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
      ],
      child: _UserProfileScreen(uid),
    );
  }
}

class _UserProfileScreen extends StatelessWidget {
  const _UserProfileScreen(this.uid);

  final String? uid;

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
          context.read<SUserProfileCubit>().getUserInfoByUid();
          context.read<CountFriendCubit>().fetchFriendsCount();
          context.read<GetFriendCubit>().getFriendStatusWithUser();
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
            const SizedBox(height: 12.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFriendsView(context),
                ],
              ),
            ),
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
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                _buildFriendView(currentUid, uid ?? "")
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: BlocBuilder<CountFriendCubit, CountFriendState>(
          builder: (context, state) {
            if (state is CountFriendLoading) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainer
                      .withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: 120.0,
                height: 40.0,
              );
            }
            if (state is CountFriendLoaded) {
              return _buildFriendsItem(
                context: context,
                label: "Friends",
                content: "${state.friendsCount}",
                onTap: () {
                  // Navigate to the friends list or perform other actions
                },
              );
            }
            return const SizedBox.shrink(); // Default empty state
          },
        ),
      ),
    );
  }

  Widget _buildFriendsItem({
    required BuildContext context,
    required String label,
    required String content,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 10.0),
              Text(
                content,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
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
                child: const Text(
                  "Send Request",
                  style: TextStyle(
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
                child: const Text(
                  "Cancel request",
                  style: TextStyle(
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
                    child: const Text(
                      "Accept",
                      style: TextStyle(
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
                    child: const Text(
                      "Decline",
                      style: TextStyle(
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
                child: const Text(
                  "Unfriend",
                  style: TextStyle(
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
}
