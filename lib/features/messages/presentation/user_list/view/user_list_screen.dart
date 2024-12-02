import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/features/messages/presentation/user_list/view/user_tile.dart';

import '../../../../../core/utils/app_router/app_router.dart';
import '../../../../../di/injection_container.dart';
import '../../../../../generated/l10n.dart';
import '../../chat/view/chat_screen.dart';
import '../logic/user_list_cubit.dart';
import '../logic/user_list_state.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserListCubit(userRepository: serviceLocator()),
      child: const _UserListScreen(),
    );
  }
}

class _UserListScreen extends StatefulWidget {
  const _UserListScreen();

  @override
  State<_UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<_UserListScreen> {
  final _auth = FirebaseAuth.instance;
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  @override
  void initState() {
    context.read<UserListCubit>().getUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).message),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<UserListCubit>().getUserList();
        },
        child: _buildUserList(context),
      ),
    );
  }
  
  Widget _buildUserList(BuildContext buildContext) {
    return BlocBuilder<UserListCubit, UserListState>(
      builder: (blocBuilderContext, state) {
        if (state is UserListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserListLoaded) {
          // Skip the current user
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.users.length - 1,
            itemBuilder: (iBContext, index) {
              final user = state.users[index];
              final String userEmail = user.email ?? "No email";
              if (userEmail == currentUserEmail) {
                return const SizedBox();
              }
              return Container(
                padding: const EdgeInsets.all(8),
                child: Column (
                  children: [
                    UserTile(
                      user: user,
                      onTap: () async {
                        context.push("${RouterUri.chat}/${user.id}", extra: user);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state is UserListError) {
          return Center(
            child: Text('Error: ${state.error}'),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
