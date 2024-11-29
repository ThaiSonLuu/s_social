import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/features/screen/home/logic/post_cubit.dart';
import 'package:s_social/features/screen/home/logic/post_state.dart';
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
    final user = context.watch<ProfileUserCubit>().currentUser;
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
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        List<PostModel> posts = [];
        bool isLoading = false;
        bool isError = false;

        if (state is PostLoading) {
          isLoading = true;
        }

        if (state is PostLoaded) {
          posts = state.posts;
        }

        if (state is PostError) {
          isError = true;
        }

        posts.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        return ListView.separated(
          itemCount: posts.length + 1,
          itemBuilder: (context, index) {
            if (isLoading) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderView(user),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  const ShimmerPost(),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  const ShimmerPost(),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  const ShimmerPost(),
                ],
              );
            }

            if (isError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderView(user),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 500.0,
                    child: Center(
                      child: Text(
                        S.of(context).an_error_occur,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }

            if (posts.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderView(user),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 500.0,
                    child: Center(
                      child: Text(S.of(context).no_post_available),
                    ),
                  ),
                ],
              );
            }

            if (index == 0) {
              return _buildHeaderView(user);
            }

            final post = posts[index - 1];

            return FutureBuilder<UserModel?>(
              future: context.read<PostCubit>().getUserById(post.userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return PostWidget(
                    postData: post,
                    userData: snapshot.data!,
                  );
                }

                return const ShimmerPost();
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
