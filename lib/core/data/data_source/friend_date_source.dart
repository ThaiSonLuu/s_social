import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/common/app_constants/firestore_collection_constants.dart';
import 'package:s_social/core/domain/model/friend_model.dart';

class FriendDataSource {
  final CollectionReference _collection = FirebaseFirestore.instance
      .collection(FirestoreCollectionConstants.friends);

  /// Get the friendship status with another user.
  Future<FriendStatusModel> getFriendStatusWithUser(
    String currentUserId,
    String otherUserId,
  ) async {
    try {
      // Check if there is a pending or accepted request where the current user is the sender
      final sentQuerySnapshot = await _collection
          .where('senderId', isEqualTo: currentUserId)
          .where('receiverId', isEqualTo: otherUserId)
          .get();

      if (sentQuerySnapshot.docs.isNotEmpty) {
        final request = FriendModel.fromJson(
            sentQuerySnapshot.docs.first.data() as Map<String, dynamic>);
        return FriendStatusModel(
          id: request.id,
          status: request.state == FriendState.pending
              ? FriendStatus.waiting
              : FriendStatus.friend,
        );
      }

      // Check if there is a pending or accepted request where the current user is the receiver
      final receivedQuerySnapshot = await _collection
          .where('receiverId', isEqualTo: currentUserId)
          .where('senderId', isEqualTo: otherUserId)
          .get();

      if (receivedQuerySnapshot.docs.isNotEmpty) {
        final request = FriendModel.fromJson(
            receivedQuerySnapshot.docs.first.data() as Map<String, dynamic>);
        return FriendStatusModel(
          id: request.id,
          status: request.state == FriendState.pending
              ? FriendStatus.needResponse
              : FriendStatus.friend,
        );
      }

      // No relationship found
      return FriendStatusModel(
        id: '',
        status: FriendStatus.notExist,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Send a friend request.
  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId,
  }) async {
    final friendRequestDoc = _collection.doc();
    final friendRequest = FriendModel(
      id: friendRequestDoc.id,
      senderId: senderId,
      receiverId: receiverId,
      dateTimeSent: DateTime.now(),
      state: FriendState.pending,
    );

    await friendRequestDoc.set(friendRequest.toJson());
  }

  /// Accept a friend request.
  Future<void> acceptFriendRequest(String requestId) async {
    await _collection.doc(requestId).update({
      'state': FriendState.accepted.name,
      'dateTimeResponded': DateTime.now().toIso8601String(),
    });
  }

  /// Decline a friend request.
  Future<void> declineFriendRequest(String requestId) async {
    await _collection.doc(requestId).delete();
  }

  /// Get a list of the current user's friends.
  Future<List<FriendModel>> getCurrentUserFriends(String userId) async {
    try {
      final friendRequestsSnapshot = await _collection
          .where('state', isEqualTo: FriendState.accepted.name)
          .where('senderId', isEqualTo: userId)
          .get();

      final receiverRequestsSnapshot = await _collection
          .where('state', isEqualTo: FriendState.accepted.name)
          .where('receiverId', isEqualTo: userId)
          .get();

      final friends = <FriendModel>[];

      // Add sender friends to the list
      friends.addAll(friendRequestsSnapshot.docs.map(
          (doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>)));

      // Add receiver friends to the list
      friends.addAll(receiverRequestsSnapshot.docs.map(
          (doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>)));

      return friends;
    } catch (e) {
      rethrow;
    }
  }

  /// Get a list of pending friend requests for the current user.
  Future<List<FriendModel>> getPendingFriendRequests(String userId) async {
    final querySnapshot = await _collection
        .where('state', isEqualTo: FriendState.pending.name)
        .where('receiverId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
