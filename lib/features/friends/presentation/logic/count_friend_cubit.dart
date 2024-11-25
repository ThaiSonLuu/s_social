import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/repository/friend_repository.dart';

part 'count_friend_state.dart';

class CountFriendCubit extends Cubit<CountFriendState> {
  final FriendRepository friendRepository;
  final String? uid;

  CountFriendCubit(this.friendRepository, this.uid)
      : super(CountFriendInitial());

  Future<void> fetchFriendsCount() async {
    if (uid == null) {
      return;
    }
    emit(CountFriendLoading());
    try {
      final friendsCount = await friendRepository.getCurrentUserFriends(uid!);
      emit(CountFriendLoaded(friendsCount.length));
    } catch (e) {
      emit(CountFriendError(e.toString()));
    }
  }
}
