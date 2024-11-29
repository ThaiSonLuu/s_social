import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/features/screen/home/logic/post_cubit.dart';
import 'package:s_social/features/screen/home/view/new_post_screen.dart';
import 'package:s_social/features/screen/home/view/widget/post_widget.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/gen/assets.gen.dart';
import 'package:s_social/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
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
    final user = context.read<ProfileUserCubit>().currentUser;
    return Scaffold(
      appBar: _buildTopAppBar(),
      body: RefreshIndicator(
        onRefresh: () => _refreshPosts(context),
        child: _buildListPostView(user),
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            Assets.images.logoS.path,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 6.0),
          // Hard code: logo (S) + text (Social)
          const Text(
            "Social",
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildHeaderView(UserModel? user) {
    final avatar = user?.avatarUrl;
    final username = user?.username;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          avatar != null
              ? CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    avatar,
                  ),
                  onBackgroundImageError: (error, stackTrace) {
                    // Handle error when loading avatar
                  },
                )
              : Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: TextToImage(
                    text: username.toString()[0],
                    textSize: 16.0,
                  ),
                ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final newPost = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPostScreen()),
                );
                if (mounted && newPost != null) {
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
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListPostView(UserModel? user) {
    return BlocBuilder<PostCubit, List<PostModel>>(
      builder: (context, posts) {
        if (posts.isEmpty) {
          return const Center(child: Text('No posts available.'));
        }

        final sortedPosts = List<PostModel>.from(posts)
          ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        return ListView.separated(
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeaderView(user);
            }

            final post = sortedPosts[index - 1];

            return FutureBuilder<UserModel>(
              future: context.read<PostCubit>().getUserById(post.userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching user.'));
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text('User not found.'),
                  );
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
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.grey,
              thickness: 0.5,
            );
          },
        );
      },
    );
  }
}
