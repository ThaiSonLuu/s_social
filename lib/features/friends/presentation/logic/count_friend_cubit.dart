import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/domain/repository/friend_repository.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';

part 'count_friend_state.dart';

class CountFriendCubit extends Cubit<CountFriendState> {
  final FriendRepository friendRepository;
  final UserRepository userRepository;
  final String? uid;

  CountFriendCubit(
    this.friendRepository,
    this.userRepository,
    this.uid,
  ) : super(CountFriendInitial());

  Future<void> fetchFriendsCount() async {
    if (uid == null) {
      return;
    }
    emit(CountFriendLoading());
    try {
      final friendsModel = await friendRepository.getCurrentUserFriends(uid!);
      final friendsId = friendsModel.map((friendModel) {
        String friendId;
        if (friendModel.senderId == uid) {
          friendId = friendModel.receiverId;
        } else {
          friendId = friendModel.senderId;
        }
        return friendId;
      }).toList();

      final users = await userRepository.getUsersByIds(friendsId);

      emit(CountFriendLoaded(users ?? []));
    } catch (e) {
      emit(CountFriendError(e.toString()));
    }
  }
}
