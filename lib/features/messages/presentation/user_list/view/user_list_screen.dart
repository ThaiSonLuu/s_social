import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:s_social/features/messages/presentation/chat/logic/chat_cubit.dart';
import 'package:s_social/features/messages/presentation/user_list/view/user_tile.dart';

import '../../../../../core/domain/model/message_model.dart';
import '../../../../../core/domain/model/user_model.dart';
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
        create: (context) => UserListCubit(
          chatRepository: serviceLocator(),
          userRepository: serviceLocator(),
          friendRepository: serviceLocator(),
        ),
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
  final _currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  final _currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    context.read<UserListCubit>().getUserList(_currentUserUid);
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
          context.read<UserListCubit>().getUserList(_currentUserUid);
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
        } 
        
        if (state is UserListLoaded) {
          // Cast the userChatMap to a list
          final userChatMap = state.userChatMap.entries.toList();

          // Sort the userChatMap by the latest message
          sortUserChatMap(userChatMap);

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: userChatMap.length,
            itemBuilder: (iBContext, index) {
              final user = userChatMap[index].key;
              final String userEmail = user.email ?? S.of(context).no_email;

              // Skip the current user
              if (userEmail == _currentUserEmail) {
                return const SizedBox();
              }

              return Container(
                padding: const EdgeInsets.all(8),
                child: Column (
                  children: [
                    UserTile(
                      user: user,
                      latestMessage: userChatMap[index].value,
                      onTap: () async {
                        context.push("${RouterUri.chat}/${user.id}", extra: user);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }

        if (state is UserListUpdated) {
          final userChatMap = state.userChatMap.entries.toList();
          sortUserChatMap(userChatMap);
        }
        
        if (state is UserListError) {
          return Center(
            child: Text('Error: ${state.error}'),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
  
  String _getChatId(String? currentUserId, String? otherUserId) {
    if (currentUserId == null || otherUserId == null) {
      return '';
    }
    final chatId = [currentUserId, otherUserId].toList()..sort();
    return chatId.join();
  }

  void sortUserChatMap(List<MapEntry<UserModel, MessageModel?>> userChatMap) {
    userChatMap.sort((a, b) {
      final aMessage = a.value;
      final bMessage = b.value;
      if (aMessage == null && bMessage == null) {
        return 0;
      }
      if (aMessage == null) {
        return 1;
      }
      if (bMessage == null) {
        return -1;
      }
      return bMessage.createdAt.compareTo(aMessage.createdAt);
    });
  }
}
