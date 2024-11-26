import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/common/app_constants/firestore_collection_constants.dart';
import 'package:s_social/core/domain/model/friend_model.dart';

class FriendDataSource {
  final CollectionReference _collection = FirebaseFirestore.instance
      .collection(FirestoreCollectionConstants.friends);

  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId,
  }) async {
    final friendRequestDoc = _collection.doc();
    final friendRequest = FriendModel(
      id: friendRequestDoc.id,
      // Use Firestore-generated ID
      senderId: senderId,
      receiverId: receiverId,
      dateTimeSent: DateTime.now(),
      state: FriendState.pending,
    );

    await friendRequestDoc.set(friendRequest.toJson());
  }

  Future<void> updateFriendRequestState({
    required String requestId,
    required FriendState newState,
  }) async {
    await _collection.doc(requestId).update({
      'state': newState.name,
      if (newState != FriendState.pending)
        'dateTimeResponded': FieldValue.serverTimestamp(),
    });
  }

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
