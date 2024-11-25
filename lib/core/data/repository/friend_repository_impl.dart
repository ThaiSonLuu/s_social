import 'package:s_social/core/data/data_source/friend_date_source.dart';
import 'package:s_social/core/domain/model/friend_model.dart';
import 'package:s_social/core/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendDataSource friendDataSource;

  FriendRepositoryImpl({required this.friendDataSource});

  @override
  Future<void> sendFriendRequest(FriendModel friendRequest) {
    return friendDataSource.sendFriendRequest(friendRequest);
  }

  @override
  Future<List<FriendModel>> getFriendRequestsByUser(String userId) {
    return friendDataSource.getFriendRequestsByUser(userId);
  }

  @override
  Future<List<FriendModel>> getSentFriendRequests(String senderId) {
    return friendDataSource.getSentFriendRequests(senderId);
  }

  @override
  Future<void> updateFriendRequestStatus({
    required String requestId,
    DateTime? acceptedDateTime,
    DateTime? declinedDateTime,
  }) {
    return friendDataSource.updateFriendRequestStatus(
      requestId: requestId,
      acceptedDateTime: acceptedDateTime,
      declinedDateTime: declinedDateTime,
    );
  }

  @override
  Future<List<FriendModel>> getCurrentUserFriends(String userId) {
    return friendDataSource.getCurrentUserFriends(userId);
  }
}
