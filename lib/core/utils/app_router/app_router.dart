import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/presentation/logic/cubit/auth/auth_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/bottom_navigation.dart';
import 'package:s_social/features/auth/presentation/login/view/login_screen.dart';
import 'package:s_social/features/auth/presentation/sign_up/view/signup_screen.dart';
import 'package:s_social/features/messages/presentation/user_list/view/user_list_screen.dart';
import 'package:s_social/features/notifications/presentation/logic/unread_notification_cubit.dart';
import 'package:s_social/features/notifications/presentation/view/notifications_screen.dart';
import 'package:s_social/features/screen/home/view/home_screen.dart';
import 'package:s_social/features/settings/presentation/change_password/view/change_password_screen.dart';
import 'package:s_social/features/settings/presentation/settings/view/settings_creen.dart';
import 'package:s_social/features/user_profile/presentation/edit_user_profile/view/edit_user_profile_screen.dart';
import 'package:s_social/features/user_profile/presentation/user_profile/view/s_user_profile_screen.dart';

abstract class RouterUri {
  static const login = "/login";
  static const signup = "/signup";
  static const messages = "/messages";
  static const notifications = "/notifications";
  static const settings = "/settings";
  static const profile = "/profile";
  static const editProfile = "/editProfile";
  static const changePassword = "/changePassword";
  static const home = "/home";
  static const chat = "/chat";
}

class AppRouter {
  AppRouter(this.authCubit, this.unreadNotificationsCubit);

  final AuthCubit authCubit;
  final UnreadNotificationsCubit unreadNotificationsCubit;

  late final GoRouter routers = GoRouter(
    routes: [
      GoRoute(
        path: RouterUri.login,
        pageBuilder: (context, state) => const MaterialPage<void>(
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouterUri.signup,
        pageBuilder: (context, state) => const MaterialPage<void>(
          child: SignUpScreen(),
        ),
      ),
      ShellRoute(
        routes: [
          GoRoute(
            path: RouterUri.home,
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: RouterUri.messages,
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: Center(
                child: UserListScreen(),
              ),
            ),
          ),
          GoRoute(
            path: RouterUri.notifications,
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: NotificationsScreen(),
            ),
          ),
          GoRoute(
            path: RouterUri.settings,
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: Center(
                child: SettingsScreen(),
              ),
            ),
          ),
        ],
        builder: (context, state, child) {
          return Scaffold(
            bottomNavigationBar: BlocProvider.value(
              value: unreadNotificationsCubit,
              child: BottomNavigation(),
            ),
            body: child,
          );
        },
      ),
      GoRoute(
        path: RouterUri.changePassword,
        pageBuilder: (context, state) => const MaterialPage<void>(
          child: ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: "${RouterUri.profile}/:uid",
        pageBuilder: (context, state) => MaterialPage<void>(
          child: SUserProfileScreen(uid: state.pathParameters["uid"]),
        ),
      ),
      GoRoute(
        path: "${RouterUri.editProfile}/:uid",
        pageBuilder: (context, state) => MaterialPage<void>(
          child: EditUserProfileScreen(uid: state.pathParameters["uid"]),
        ),
      ),
    ],
    initialLocation: RouterUri.login,
    redirect: (context, state) {
      final isLoggedIn = authCubit.state.isLoggedIn;
      final isLoggingIn = state.matchedLocation == RouterUri.login ||
          state.matchedLocation == RouterUri.signup;

      if (!isLoggedIn && !isLoggingIn) {
        return RouterUri.login;
      }

      if (isLoggedIn && isLoggingIn) {
        return RouterUri.home;
      }

      return null;
    },
    refreshListenable: GoRouterRefresh(authCubit.stream),
  );
}

class GoRouterRefresh extends ChangeNotifier {
  GoRouterRefresh(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  StreamSubscription<dynamic>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
