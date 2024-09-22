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
    final List<Map<String, String>> newsFeedData = [
      {
        'title': 'Post 1',
        'description': 'This is the first post description.',
        'image': 'https://via.placeholder.com/150',
      },
      {
        'title': 'Post 2',
        'description': 'This is the second post description.',
        'image': 'https://via.placeholder.com/150',
      },
      {
        'title': 'Post 3',
        'description': 'This is the third post description.',
        'image': 'https://via.placeholder.com/150',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).news_feed),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Language and Theme Switches
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.read<AppLanguageCubit>().state.languageCode),
              const SizedBox(width: 20),
              Switch(
                value: context.read<AppLanguageCubit>().state.languageCode == "en",
                onChanged: (value) {
                  context.read<AppLanguageCubit>().setLanguageCode(value ? "en" : "vi");
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.read<AppThemeCubit>().state.isDarkTheme ? "Dark" : "Light"),
              const SizedBox(width: 20),
              Switch(
                value: context.read<AppThemeCubit>().state.isDarkTheme,
                onChanged: (value) {
                  context.read<AppThemeCubit>().setTheme(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Displaying the Username
          Text(
            username != null ? S.of(context).hello(username!) : S.of(context).hello_user,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),

          // News Feed Section
          Expanded(
            child: ListView.builder(
              itemCount: newsFeedData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(newsFeedData[index]['image']!),
                    title: Text(newsFeedData[index]['title']!),
                    subtitle: Text(newsFeedData[index]['description']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
