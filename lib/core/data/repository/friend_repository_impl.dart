import 'package:s_social/core/data/data_source/friend_date_source.dart';
import 'package:s_social/core/domain/model/friend_model.dart';
import 'package:s_social/core/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendDataSource dataSource;

  FriendRepositoryImpl({required this.dataSource});

  @override
  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId,
  }) async {
    // Using Firestore to generate a unique document ID for the friend request
    await dataSource.sendFriendRequest(
      senderId: senderId,
      receiverId: receiverId,
    );
  }

  @override
  Future<void> acceptFriendRequest({
    required String requestId,
  }) async {
    // Accept the request by updating the state in Firestore
    await dataSource.updateFriendRequestState(
      requestId: requestId,
      newState: FriendState.accepted,
    );
  }

  @override
  Future<void> declineFriendRequest({
    required String requestId,
  }) async {
    // Decline the request by updating the state in Firestore
    await dataSource.updateFriendRequestState(
      requestId: requestId,
      newState: FriendState.declined,
    );
  }

  @override
  Future<List<FriendModel>> getCurrentUserFriends(String userId) async {
    // Fetch current user's friends by querying the Firestore collection
    return await dataSource.getCurrentUserFriends(userId);
  }

  @override
  Future<List<FriendModel>> getPendingRequests(String userId) async {
    // Fetch pending friend requests for the current user
    return await dataSource.getPendingFriendRequests(userId);
  }
}
