import 'package:s_social/core/domain/model/friend_model.dart';

abstract class FriendRepository {
  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId,
  });

  Future<void> acceptFriendRequest({
    required String requestId,
  });

  Future<void> declineFriendRequest({
    required String requestId,
  });

  Future<List<FriendModel>> getCurrentUserFriends(String userId);

  Future<List<FriendModel>> getPendingRequests(String userId);
}
