import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/cubit/app_language/app_language_cubit.dart';
import 'package:s_social/core/cubit/app_theme/app_theme_cubit.dart';
import 'package:s_social/core/cubit/auth/auth_cubit.dart';
import 'package:s_social/generated/l10n.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  String? username;

  @override
  void initState() {
    super.initState();
    getUserNameFromFirebaseAuth();
  }

  Future<void> getUserNameFromFirebaseAuth() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        username = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.read<AppLanguageCubit>().state.languageCode),
                const SizedBox(width: 20),
                Switch(
                  value: context.read<AppLanguageCubit>().state.languageCode ==
                      "en",
                  onChanged: (value) {
                    context
                        .read<AppLanguageCubit>()
                        .setLanguageCode(value ? "en" : "vi");
                  },
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.read<AppThemeCubit>().state.isDarkTheme ? "Dark" :"Light"),
                const SizedBox(width: 20),
                Switch(
                  value: context.read<AppThemeCubit>().state.isDarkTheme,
                  onChanged: (value) {
                    context
                        .read<AppThemeCubit>()
                        .setTheme(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(username != null ? S.of(context).hello(username!) : S.of(context).hello_user),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              child: Text(S.of(context).logout),
            ),
          ],
        ),
      ),
    );
  }
}
