import 'package:s_social/core/domain/model/friend_model.dart';

abstract class FriendRepository {
  Future<FriendStatusModel> getFriendStatusWithUser(
      String currentUserId, String otherUserId);

  Future<void> sendFriendRequest(
      {required String senderId, required String receiverId});

  Future<void> acceptFriendRequest(String requestId);

  Future<void> declineFriendRequest(String requestId);

  Future<List<FriendModel>> getCurrentUserFriends(String userId);

  Future<List<FriendModel>> getPendingFriendRequests(String userId);
}
