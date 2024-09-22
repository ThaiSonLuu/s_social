import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/core/cubit/auth/auth_cubit.dart';
import 'package:s_social/features/auth/presentation/login/view/login_screen.dart';
import 'package:s_social/features/auth/presentation/sign_up/view/signup_screen.dart';
import 'package:s_social/features/news_feed/presentation/news_feed_screen.dart';
import 'package:s_social/features/home/home_screen.dart';
import 'package:s_social/features/post/post_screen.dart';
import 'package:s_social/features/profile/profile_screen.dart';

class RouterUri {
  static const login = "/login";
  static const signup = "/signup";
  static const newsFeeds = "/news-feeds";
  static const home = "/home";
  static const post = "/post";
  static const profile = "/profile";
}

class AppRouter {
  AppRouter(this.authCubit);

  final AuthCubit authCubit;

  GoRouter get routers {
    return GoRouter(
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
        GoRoute(
            path: RouterUri.home,
            pageBuilder: (context, state) => const MaterialPage<void>(
                  child: HomeScreen(),
                )),
        GoRoute(
          path: RouterUri.newsFeeds,
          pageBuilder: (context, state) => const MaterialPage<void>(
            child: NewsFeedScreen(),
          ),
        ),
        GoRoute(
            path: RouterUri.post,
            pageBuilder: (context, state) => MaterialPage<void>(
                  child: PostScreen(),
                )),
        GoRoute(
          path: RouterUri.profile,
          pageBuilder: (context, state) => MaterialPage<void>(
            child: ProfileScreen(),
          ),
        )
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

        // if (isLoggedIn && isLoggingIn) {
        //   return RouterUri.newsFeeds;
        // }

        return null;
      },
      refreshListenable: GoRouterRefresh(authCubit.stream),
    );
  }
}

class GoRouterRefresh extends ChangeNotifier {
  GoRouterRefresh(Stream<dynamic> stream) {
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
