import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/core/domain/model/friend_model.dart';

class FriendDataSource {
  CollectionReference get _friendRequestsCollection {
    return FirebaseFirestore.instance.collection('friendRequests');
  }

  Future<void> sendFriendRequest(FriendModel friendRequest) async {
    final docRef = _friendRequestsCollection.doc();
    final requestWithId = friendRequest.copyWith(id: docRef.id);
    await docRef.set(requestWithId.toJson());
  }

  Future<List<FriendModel>> getFriendRequestsByUser(String userId) async {
    final querySnapshot = await _friendRequestsCollection
        .where('receiverId', isEqualTo: userId)
        .get();
    return querySnapshot.docs
        .map((doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<FriendModel>> getSentFriendRequests(String senderId) async {
    final querySnapshot = await _friendRequestsCollection
        .where('senderId', isEqualTo: senderId)
        .get();
    return querySnapshot.docs
        .map((doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateFriendRequestStatus({
    required String requestId,
    DateTime? acceptedDateTime,
    DateTime? declinedDateTime,
  }) async {
    final updateData = <String, dynamic>{};
    if (acceptedDateTime != null) {
      updateData['dateTimeAccepted'] = acceptedDateTime.toIso8601String();
    }
    if (declinedDateTime != null) {
      updateData['dateTimeDeclined'] = declinedDateTime.toIso8601String();
    }

    await _friendRequestsCollection.doc(requestId).update(updateData);
  }

  Future<List<FriendModel>> getCurrentUserFriends(String userId) async {
    final querySnapshot = await _friendRequestsCollection
        .where('receiverId', isEqualTo: userId)
        .where('dateTimeAccepted', isNotEqualTo: null)
        .get();
    return querySnapshot.docs
        .map((doc) => FriendModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
