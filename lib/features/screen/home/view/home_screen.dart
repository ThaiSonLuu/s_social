import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/presentation/view/widgets/text_to_image.dart';
import 'package:s_social/core/utils/ui/cache_image.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/screen/home/logic/comment_cubit.dart';
import 'package:s_social/features/screen/home/logic/post_cubit.dart';
import 'package:s_social/features/screen/home/logic/post_state.dart';
import 'package:s_social/features/screen/home/view/new_post_screen.dart';
import 'package:s_social/features/screen/home/view/widget/post_widget.dart';
import 'package:s_social/gen/assets.gen.dart';
import 'package:s_social/generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => PostCubit(
          postRepository: serviceLocator(),
          uploadFileRepository: serviceLocator(),
          userRepository: serviceLocator(),
        ),
      ),
      BlocProvider(
        create: (context) => CommentCubit(
          commentRepository: serviceLocator(),
          uploadFileRepository: serviceLocator(),
        ),
      )
    ], child: const _HomeScreen());
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
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
              ? Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CacheImage(
                    imageUrl: avatar,
                    loadingWidth: 40,
                    loadingHeight: 40,
                  ),
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
                final shouldReload = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewPostScreen(),
                  ),
                );
                if (mounted && shouldReload == true) {
                  context.read<PostCubit>().loadPosts();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  S.of(context).new_post_box,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
        List<ShowPost> showPosts = [];
        bool isLoading = false;
        bool isError = false;

        if (state is PostLoading) {
          isLoading = true;
        }

        if (state is PostLoaded) {
          showPosts = state.posts;
        }

        if (state is PostError) {
          isError = true;
        }

        showPosts
            .sort((a, b) => b.post.createdAt!.compareTo(a.post.createdAt!));

        return ListView.separated(
          itemCount: showPosts.length + 1,
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

            if (showPosts.isEmpty) {
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

            final showPost = showPosts[index - 1];

            return PostWidget(
              postData: showPost.post,
              userData: showPost.user,
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
