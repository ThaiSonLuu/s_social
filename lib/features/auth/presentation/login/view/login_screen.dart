import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/presentation/logic/cubit/auth/auth_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/text_field.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/core/utils/snack_bar.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/auth/presentation/login/logic/login_cubit.dart';
import 'package:s_social/features/notifications/presentation/logic/unread_notification_cubit.dart';
import 'package:s_social/gen/assets.gen.dart';
import 'package:s_social/generated/l10n.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        userRepository: serviceLocator(),
        notificationRepository: serviceLocator(),
      ),
      child: const _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool get enableButton =>
      emailCtrl.text.length >= 4 && passwordCtrl.text.length >= 4;

  bool isVisiblePassword = false;

  @override
  void initState() {
    super.initState();
    emailCtrl.addListener(() {
      setState(() {});
    });
    passwordCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoaded) {
            context.read<AuthCubit>().login();
            context.read<ProfileUserCubit>().getUserInfo();
            context.read<UnreadNotificationsCubit>().listenToUnreadCount();
          }

          if (state is LoginError) {
            context.showSnackBarFail(text: state.error);
          }

          if (state is LoginLoading) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Stack(
          children: [
            _buildBody(),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return _buildDialogProgress();
                }

                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.logoS.path,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 80.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              child: STextField(
                controller: emailCtrl,
                labelText: S.of(context).email,
                hintText: S.of(context).enter_your_email,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              child: STextField(
                controller: passwordCtrl,
                labelText: S.of(context).password,
                hintText: S.of(context).enter_your_password,
                obscureText: !isVisiblePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisiblePassword = !isVisiblePassword;
                    });
                  },
                  icon: Icon(
                    isVisiblePassword ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              width: double.maxFinite,
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return FilledButton(
                    onPressed: enableButton && state is! LoginLoading
                        ? () async {
                            await context.read<LoginCubit>().loginWithAccount(
                                  email: emailCtrl.text,
                                  password: passwordCtrl.text,
                                );
                          }
                        : null,
                    child: Text(S.of(context).login),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 5,
                  ),
                  child: const Divider(),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).colorScheme.surface,
                  child: Text(S.of(context).or),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await context.read<LoginCubit>().loginWithGoogle();
                  },
                  child: Image.asset(
                    Assets.images.logoGoogle.path,
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () async {
                    await context.read<LoginCubit>().loginWithFacebook();
                  },
                  child: Image.asset(
                    Assets.images.logoFacebook.path,
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${S.of(context).do_not_have_account} ",
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
                GestureDetector(
                  onTap: () async {
                    final user = await context.push<User>(RouterUri.signup);
                    if (user != null && mounted) {
                      context.showSnackBarSuccess(
                          text: S.of(context).sign_up_success);
                    }
                  },
                  child: Text(
                    S.of(context).create_now,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDialogProgress() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context)
              .colorScheme
              .surface
              .withOpacity(0.7)
              .withAlpha(200),
        ),
        child: const SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
