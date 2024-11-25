import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/friend_model.dart';
import 'package:s_social/core/domain/repository/friend_repository.dart';

part 'friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  final FriendRepository friendRepository;

  FriendCubit({required this.friendRepository}) : super(FriendInitial());

  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    emit(FriendLoading());
    try {
      await friendRepository.sendFriendRequest(
        senderId: senderId,
        receiverId: receiverId,
      );
      emit(FriendRequestSent());
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> acceptRequest(
    String requestId,
  ) async {
    emit(FriendLoading());
    try {
      await friendRepository.acceptFriendRequest(requestId: requestId);
      emit(FriendRequestStatusChanged());
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> declineRequest(
    String requestId,
  ) async {
    emit(FriendLoading());
    try {
      await friendRepository.declineFriendRequest(requestId: requestId);
      emit(FriendRequestStatusChanged());
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }

  Future<void> getPendingRequests(String userId) async {
    emit(FriendLoading());
    try {
      final pendingRequests = await friendRepository.getPendingRequests(userId);
      emit(FriendRequestsLoaded(pendingRequests));
    } catch (e) {
      emit(FriendError(e.toString()));
    }
  }
}
