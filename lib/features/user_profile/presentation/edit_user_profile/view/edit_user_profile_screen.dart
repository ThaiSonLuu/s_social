import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/user_profile/presentation/user_profile/logic/s_user_profile_cubit.dart';
import 'package:s_social/gen/assets.gen.dart';
import 'package:s_social/generated/l10n.dart';

class EditUserProfileScreen extends StatelessWidget {
  const EditUserProfileScreen({
    super.key,
    required this.uid,
    this.isMyself = false,
  });

  final String? uid;
  final bool isMyself;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SUserProfileCubit(
        userRepository: serviceLocator(),
        uid: uid,
      )..getUserInfoByUid(),
      child: const _UserProfileScreen(),
    );
  }
}

class _UserProfileScreen extends StatelessWidget {
  const _UserProfileScreen();

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
            _buildFollowingView(context: context),
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
        child: Stack(
          children: [
            isLoading
                ? Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  )
                : SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: Image.network(
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
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      },
                    ),
                  ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainer
                      .withOpacity(0.6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit),
                      const SizedBox(width: 8.0),
                      Text(S.of(context).edit),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Container(
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
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                  ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainer
                    .withOpacity(0.6),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.edit),
              ),
            ),
          ),
        ],
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
      onTap: () {
        context.push(RouterUri.editProfile);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color:
              Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.6),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Save"),
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
          if (bio != null) ...[
            const SizedBox(height: 12.0),
            Text(bio),
          ],
        ],
      ),
    );
  }

  Widget _buildFollowingView({
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          _buildFollowingItem(
            context: context,
            label: "Follower",
            content: "1.3K",
          ),
          Container(
            width: 1,
            height: 50,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          _buildFollowingItem(
            context: context,
            label: "Following",
            content: "180",
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingItem({
    required BuildContext context,
    required String label,
    required String content,
  }) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(content),
        ],
      ),
    );
  }
}
