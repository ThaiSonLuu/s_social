import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/features/screen/home/view/new_post_screen.dart';
import 'package:s_social/features/screen/home/view/widget/post_widget.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import '../../../../generated/l10n.dart';
import '../logic/post_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().loadPosts();
  }

  Future<void> _refreshPosts(BuildContext context) async {
    await context.read<PostCubit>().loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).home),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final newPost = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPostScreen()),
                      );
                      if (newPost != null) {
                        context.read<PostCubit>().createPost(newPost);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          S.of(context).new_post_box,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 0.5),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshPosts(context),
              child: BlocBuilder<PostCubit, List<PostModel>>(
                builder: (context, posts) {
                  if (posts.isEmpty) {
                    return const Center(child: Text('No posts available.'));
                  }
                  return ListView.separated(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      posts.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                      return FutureBuilder<UserModel>(
                        future: context.read<PostCubit>().getUserById(post.userId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Error fetching user.'));
                          } else if (!snapshot.hasData) {
                            return const Center(child: Text('User not found.'));
                          }

                          final user = snapshot.data!;

                          return PostWidget(
                            postData: post,
                            userData: user,
                            onTap: () {
                              // Logic to handle post taps (e.g., navigate to detail screen)
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(thickness: 0.2),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
