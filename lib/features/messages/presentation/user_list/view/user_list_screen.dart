import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/features/messages/presentation/user_list/view/user_tile.dart';

import '../../../../../core/utils/app_router/app_router.dart';
import '../../../../../generated/l10n.dart';
import '../../chat/view/chat_screen.dart';
import '../logic/user_list_cubit.dart';
import '../logic/user_list_state.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserListCubit(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).message),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildUserList(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildUserList() {
    return BlocBuilder<UserListCubit, UserListState>(
      builder: (context, state) {
        if (state is UserListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserListLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return Column (
                children: [
                  UserTile(
                    user: user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(
                          recipientEmail: user.email,
                        )),
                      );
                    },
                  ),
                  Divider(
                    color:
                    Theme.of(context).colorScheme.onSurface.withAlpha(50),
                    height: 1,
                    thickness: 1,
                  ),
                ],
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
