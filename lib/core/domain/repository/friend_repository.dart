import 'package:s_social/core/domain/model/friend_model.dart';

abstract class FriendRepository {
  Future<void> sendFriendRequest(FriendModel friendRequest);

  Future<List<FriendModel>> getFriendRequestsByUser(String userId);

  Future<List<FriendModel>> getSentFriendRequests(String senderId);

  Future<void> updateFriendRequestStatus({
    required String requestId,
    DateTime? acceptedDateTime,
    DateTime? declinedDateTime,
  });

  Future<List<FriendModel>> getCurrentUserFriends(String userId);
}
