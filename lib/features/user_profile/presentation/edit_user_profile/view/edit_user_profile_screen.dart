import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/presentation/view/widgets/text_field.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/shimmer_loading.dart';
import 'package:s_social/core/utils/snack_bar.dart';
import 'package:s_social/core/utils/ui/cache_image.dart';
import 'package:s_social/core/utils/ui/dialog_loading.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/user_profile/presentation/edit_user_profile/logic/edit_user_profile_cubit.dart';
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
      create: (context) => EditUserProfileCubit(
        userRepository: serviceLocator(),
        uploadFileRepository: serviceLocator(),
        uid: uid,
      )..getUserInfoByUid(),
      child: const _UserProfileScreen(),
    );
  }
}

class _UserProfileScreen extends StatefulWidget {
  const _UserProfileScreen();

  @override
  State<_UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<_UserProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedBackground;
  File? _selectedAvatar;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _bioCtrl = TextEditingController();

  UserModel? user;

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

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<EditUserProfileCubit>().getUserInfoByUid();
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
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required AssetGenImage randomBackground,
  }) {
    return BlocBuilder<EditUserProfileCubit, EditUserProfileState>(
      builder: (context, state) {
        if (state is EditUserProfileLoading) {
          return const EditUserProfileShimmer();
        }

        String? avatarUrl;
        String? backgroundUrl;
        String? username;
        String? email;
        String? bio;

        if (state is EditUserProfileLoaded) {
          user = state.user;
          backgroundUrl = state.user.backgroundUrl;
          avatarUrl = state.user.avatarUrl;
          username = state.user.username;
          _nameCtrl.text = username ?? "";
          email = state.user.email;
          _emailCtrl.text = email ?? "";
          bio = state.user.bio;
          _bioCtrl.text = bio ?? "";
        }

        return Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: _buildBackgroundImage(
                    context: context,
                    isLoading: state is EditUserProfileLoading,
                    randomBackground: randomBackground,
                    backgroundUrl: backgroundUrl,
                  ),
                ),
                Positioned(
                  left: 20.0,
                  bottom: 0.0,
                  child: _buildAvatarImage(
                    context: context,
                    isLoading: state is EditUserProfileLoading,
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
                  child: _buildEditButton(context, user),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildNameView(
              context: context,
              username: username,
              email: email,
              bio: bio,
            ),
            const SizedBox(height: 12.0),
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
            _selectedBackground != null
                ? SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: Image.file(
                      _selectedBackground!,
                      fit: BoxFit.cover,
                    ),
                  )
                : ((backgroundUrl ?? "").isNotEmpty
                    ? SizedBox(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: CacheImage(
                          imageUrl: backgroundUrl ?? "",
                          loadingWidth: double.maxFinite,
                          loadingHeight: double.maxFinite,
                        ),
                      )
                    : Image.asset(
                        randomBackground.path,
                        fit: BoxFit.fill,
                        width: double.maxFinite,
                      )),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  final XFile? pickedFile =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedBackground = File(pickedFile.path);
                    });
                  }
                },
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
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: _selectedAvatar != null
                ? Image.file(
                    _selectedAvatar!,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  )
                : ((avatarUrl ?? "").isNotEmpty
                    ? CacheImage(
                        imageUrl: avatarUrl ?? "",
                        loadingWidth: 120,
                        loadingHeight: 120,
                      )
                    : TextToImage(
                        text: username?[0].toUpperCase() ?? "S",
                        textSize: 48,
                      )),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () async {
                final XFile? pickedFile =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _selectedAvatar = File(pickedFile.path);
                  });
                }
              },
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

  Widget _buildEditButton(
    BuildContext context,
    UserModel? user,
  ) {
    return InkWell(
      onTap: () async {
        if (user != null) {
          final errorMessage = await context.showDialogLoading<String?>(
            future: () async {
              return await context.read<EditUserProfileCubit>().updateUser(
                    backgroundImage: _selectedBackground,
                    avatarImage: _selectedAvatar,
                    user: user.copyWith(
                      username: _nameCtrl.text,
                      bio: _bioCtrl.text,
                    ),
                  );
            },
          );

          if (context.mounted) {
            if (errorMessage != null) {
              context.showSnackBarFail(text: errorMessage);
            } else {
              context.pop();
            }
          }
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
          child: Text(S.of(context).save),
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
              : STextField(
                  controller: _nameCtrl,
                  labelText: S.of(context).showing_name,
                ),
          const SizedBox(height: 14.0),
          email == null
              ? Container(
                  width: 220,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                )
              : STextField(
                  controller: _emailCtrl,
                  labelText: S.of(context).email,
                  enable: false,
                ),
          if (bio != null) ...[
            const SizedBox(height: 14.0),
            STextField(
              controller: _bioCtrl,
              labelText: S.of(context).bio,
              minLines: 5,
              maxLines: 10,
            ),
          ],
        ],
      ),
    );
  }
}

class EditUserProfileShimmer extends StatelessWidget {
  const EditUserProfileShimmer({
    super.key,
  });

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
            Positioned(
              top: 12.0,
              right: 12.0,
              child: _buildSaveButton(context),
            ),
            Positioned(
              left: 20.0,
              bottom: 0.0,
              child: _buildAvatarImage(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ShimmerLoading(
            width: double.maxFinite,
            height: 60,
            borderRadius: 12,
          ),
        ),
        const SizedBox(height: 14),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ShimmerLoading(
            width: double.maxFinite,
            height: 60,
            borderRadius: 12,
          ),
        ),
        const SizedBox(height: 14),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ShimmerLoading(
            width: double.maxFinite,
            height: 150,
            borderRadius: 12,
          ),
        ),
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

  Widget _buildSaveButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
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
          child: Text(S.of(context).save),
        ),
      ),
    );
  }
}
