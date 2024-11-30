import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/friend_model.dart';
import 'package:s_social/core/domain/model/notification_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/domain/repository/friend_repository.dart';
import 'package:s_social/core/domain/repository/notification_repository.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/core/utils/extensions/is_current_user.dart';
import 'package:s_social/generated/l10n.dart';

part 'friend_state.dart';

class GetFriendCubit extends Cubit<GetFriendState> {
  final FriendRepository _friendRepository;
  final NotificationRepository _notificationRepository;
  final String uid;

  GetFriendCubit(
    this._friendRepository,
    this._notificationRepository,
    this.uid,
  ) : super(FriendInitial());

  Future<FriendStatusModel> _getFriendStatus() async {
    return await _friendRepository.getFriendStatusWithUser(
      currentUid,
      uid,
    );
  }

  /// Fetches the friend status with a given user.
  Future<void> getFriendStatusWithUser() async {
    emit(FriendLoading());
    try {
      final friendStatus = await _getFriendStatus();
      emit(FriendLoaded(friendStatus));
    } catch (e) {
      emit(FriendError(S.current.an_error_occur));
    }
  }

  /// Sends a friend request to another user.
  Future<void> sendFriendRequest(
      {required String senderId, required String receiverId}) async {
    emit(FriendLoading());
    try {
      final friendStatus = await _getFriendStatus();

      if (friendStatus.status != FriendStatus.notExist) {
        emit(FriendLoaded(friendStatus));
        return;
      }

      await _friendRepository.sendFriendRequest(
        senderId: senderId,
        receiverId: receiverId,
      );
      await _friendRepository.getFriendStatusWithUser(senderId, receiverId);

      emit(const FriendDoneAction(FriendAction.sentRequest));

      await getFriendStatusWithUser();
    } catch (e) {
      emit(FriendError(S.current.an_error_occur));
    }
  }

  /// Accepts a friend request by changing its state to `accepted`.
  Future<void> acceptFriendRequest(String requestId) async {
    emit(FriendLoading());
    try {
      final friendStatus = await _getFriendStatus();

      if (friendStatus.status != FriendStatus.needResponse) {
        emit(FriendLoaded(friendStatus));
        return;
      }

      await _friendRepository.acceptFriendRequest(requestId);

      emit(const FriendDoneAction(FriendAction.accept));

      await getFriendStatusWithUser();
    } catch (e) {
      emit(FriendError(S.current.an_error_occur));
    }
  }

  /// Declines a friend request by deleting it.
  Future<void> declineFriendRequest(String requestId) async {
    emit(FriendLoading());
    try {
      final friendStatus = await _getFriendStatus();

      if (friendStatus.status == FriendStatus.notExist) {
        emit(FriendLoaded(friendStatus));
        return;
      }

      await _friendRepository.declineFriendRequest(requestId);
      await getFriendStatusWithUser();
    } catch (e) {
      emit(FriendError(S.current.an_error_occur));
    }
  }

  Future<void> sendNotification({
    required FriendAction action,
    required UserModel? currentUser,
    required UserModel? targetUser,
  }) async {
    final String title;
    if (action == FriendAction.sentRequest) {
      title = "${currentUser?.username} sent you a friend request";
    } else {
      title = "${currentUser?.username} accepted your friend request";
    }

    _notificationRepository.createNotification(
      NotificationModel(
        uid: uid,
        fcmToken: targetUser?.fcmTokens,
        imageUrl: currentUser?.avatarUrl,
        title: title,
        message: "Click to see detail",
        time: DateTime.now(),
        route: "${RouterUri.profile}/${currentUser?.id}",
      ),
    );
  }
}
