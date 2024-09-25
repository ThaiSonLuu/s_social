import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/cubit/app_theme/app_theme_cubit.dart';
import 'package:s_social/features/screen/home/model/post_data.dart';
import 'package:s_social/features/screen/home/model/post_widget.dart';
import 'package:s_social/features/screen/home/post_screen.dart';
import 'package:s_social/features/screen/home/new_post.dart';
import 'package:s_social/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PostData> posts = List.generate(
    10,
        (index) => PostData(
      userName: 'User $index',
      userImg: 'https://via.placeholder.com/150',
      content: 'This is the content of post $index',
      postImg: 'https://via.placeholder.com/300',
      like: index * 10,
      cmtNo: index * 5,
      share: index * 3,
    ),
  );

  void _addNewPost(PostData newPost) {
    setState(() {
      posts.insert(0, newPost);
    });
  }

  void _navigateToNewPostScreen() async {
    final newPost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPost()),
    );
    if (newPost != null) {
      _addNewPost(newPost);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.separated(
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // New Post
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    radius: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: _navigateToNewPostScreen,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: context.watch<AppThemeCubit>().state.isDarkTheme
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          S.of(context).new_post,
                          style: TextStyle(
                            color: context.watch<AppThemeCubit>().state.isDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {  // Post Screen
            final post = posts[index - 1];
            return PostWidget(
              data: post,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(postId: index - 1),
                  ),
                );
              },
            );
          }
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
            thickness: 0.5,
          );
        },
      ),
    );
  }
}
