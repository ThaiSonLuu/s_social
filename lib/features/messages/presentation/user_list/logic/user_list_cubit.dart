import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/message_model.dart';
import 'package:s_social/core/domain/repository/chat_repository.dart';

import '../../../../../common/app_constants/firestore_collection_constants.dart';
import '../../../../../core/domain/model/user_model.dart';
import '../../../../../core/domain/repository/friend_repository.dart';
import '../../../../../core/domain/repository/user_repository.dart';
import 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit({
    required ChatRepository chatRepository,
    required FriendRepository friendRepository,
    required UserRepository userRepository,
  })  : _chatRepository = chatRepository,
        _friendRepository = friendRepository,
        _userRepository = userRepository,
        super(UserListInitial());

  final ChatRepository _chatRepository;
  final FriendRepository _friendRepository;
  final UserRepository _userRepository;

  Future<void> getUserList(String? userId) async {
    emit(UserListLoading());
    try {
      var userIdChatMap = await _chatRepository.getUserChatMap(userId!);
      if (userIdChatMap == null) {
        var friendsModel = await _friendRepository.getCurrentUserFriends(userId);
        final friendsId = friendsModel.map((friendModel) {
          String friendId;
          if (friendModel.senderId == userId) {
            friendId = friendModel.receiverId;
          } else {
            friendId = friendModel.senderId;
          }
          return friendId;
        }).toList();

        userIdChatMap = <String, MessageModel?>{};
        for (var friendId in friendsId) {
          userIdChatMap.addEntries([MapEntry(friendId, null)]);
        }

        await _chatRepository.createUserChatMap(userId, userIdChatMap);
        userIdChatMap = await _chatRepository.getUserChatMap(userId);
      }
      final userChatMap = <UserModel, MessageModel?>{};
      for (var entry in userIdChatMap!.entries) {
        var user = await _userRepository.getUserById(entry.key);
        if (user != null) {
          userChatMap.addEntries([MapEntry(user, entry.value)]);
        }
      }

      emit(UserListLoaded(userChatMap));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }

  Future<void> updateUserChatMap(String userId, String recipientId, MessageModel message) async {
    try {
      emit(UserListLoading());
      // Update both sender and recipient chat map
      final userIdChatMap = await _chatRepository.updateUserChatMap(userId, recipientId, message);
      await _chatRepository.updateUserChatMap(recipientId, userId, message);

      final userChatMap = <UserModel, MessageModel?>{};
      for (var entry in userIdChatMap!.entries) {
        var user = await _userRepository.getUserById(entry.key);
        if (user != null) {
          userChatMap.addEntries([MapEntry(user, entry.value)]);
        }
      }
      emit(UserListLoaded(userChatMap));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }
}
