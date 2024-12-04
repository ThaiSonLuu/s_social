import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/presentation/logic/cubit/app_language/app_language_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/app_theme/app_theme_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/auth/auth_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/core/utils/snack_bar.dart';
import 'package:s_social/core/utils/ui/cache_image.dart';
import 'package:s_social/features/notifications/presentation/logic/unread_notification_cubit.dart';
import 'package:s_social/generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingsScreen();
  }
}

class _SettingsScreen extends StatefulWidget {
  const _SettingsScreen();

  @override
  State<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileUserCubit>().getUserInfo();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildUserInfoLabel(),
              _buildActions(),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoLabel() {
    return GestureDetector(
      onTap: () {
        final uid = context.read<ProfileUserCubit>().currentUser?.id;
        context.push("${RouterUri.profile}/$uid");
      },
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: BlocBuilder<ProfileUserCubit, ProfileUserState>(
          builder: (context, state) {
            String? avatarUrl;
            String? username;
            String? email;

            if (state is ProfileUserLoaded) {
              avatarUrl = state.user.avatarUrl;
              username = state.user.username;
              email = state.user.email;
            }

            return Row(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: avatarUrl == null
                      ? SizedBox(
                          width: 60,
                          height: 60,
                          child: TextToImage(
                            text: username?[0].toUpperCase() ?? "S",
                          ),
                        )
                      : CacheImage(
                          imageUrl: avatarUrl,
                          loadingWidth: 60,
                          loadingHeight: 60,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      username == null
                          ? Container(
                              width: 100,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            )
                          : Text(
                              username,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                      const SizedBox(height: 4.0),
                      email == null
                          ? Container(
                              width: 200,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            )
                          : Text(email),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          BlocBuilder<ProfileUserCubit, ProfileUserState>(
            builder: (context, state) {
              if (state is ProfileUserLoaded &&
                  state.user.signInType == SignInType.emailAndPassword) {
                return Column(
                  children: [
                    _buildActionItem(
                      icon: const Icon(Icons.password),
                      label: S.of(context).change_password,
                      onTap: () async {
                        final result =
                            await context.push(RouterUri.changePassword);
                        if (result == true && context.mounted) {
                          context.showSnackBarSuccess(
                              text: S.of(context).change_password_success);
                        }
                      },
                      trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    ),
                    Divider(
                      color:
                          Theme.of(context).colorScheme.onSurface.withAlpha(50),
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
          _buildActionItem(
            icon: const Icon(Icons.language),
            label: S.of(context).language,
            onTap: null,
            trailing: DropdownMenu(
              initialSelection:
                  context.read<AppLanguageCubit>().state.languageCode,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: "en", label: S.of(context).english),
                DropdownMenuEntry(value: "vi", label: S.of(context).vietnamese),
              ],
              inputDecorationTheme: const InputDecorationTheme(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 12.0,
                ),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              textStyle: Theme.of(context).textTheme.bodyMedium,
              onSelected: (value) {
                if (value != null) {
                  context.read<AppLanguageCubit>().setLanguageCode(value);
                }
              },
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
            height: 1,
            thickness: 1,
          ),
          _buildActionItem(
            icon: const Icon(Icons.ac_unit_sharp),
            label: S.of(context).dark_theme,
            onTap: null,
            trailing: Switch(
              value: context.watch<AppThemeCubit>().state.isDarkTheme,
              onChanged: (value) {
                context.read<AppThemeCubit>().setTheme(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: _buildActionItem(
        icon: const Icon(
          Icons.logout_outlined,
          color: Colors.red,
        ),
        label: S.of(context).logout,
        onTap: () {
          context.read<AuthCubit>().logout();
          context.read<ProfileUserCubit>().removeUserInfo();
          context.read<UnreadNotificationsCubit>().stopListenUnreadCount();
        },
        trailing: const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildActionItem({
    required Widget icon,
    required String label,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }
}
