import 'package:s_social/core/data/data_source/friend_date_source.dart';
import 'package:s_social/core/domain/model/friend_model.dart';
import 'package:s_social/core/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendDataSource _dataSource;

  FriendRepositoryImpl(this._dataSource);

  @override
  Future<FriendStatusModel> getFriendStatusWithUser(
      String currentUserId, String otherUserId) async {
    return await _dataSource.getFriendStatusWithUser(
        currentUserId, otherUserId);
  }

  @override
  Future<void> sendFriendRequest(
      {required String senderId, required String receiverId}) async {
    await _dataSource.sendFriendRequest(
        senderId: senderId, receiverId: receiverId);
  }

  @override
  Future<void> acceptFriendRequest(String requestId) async {
    await _dataSource.acceptFriendRequest(requestId);
  }

  @override
  Future<void> declineFriendRequest(String requestId) async {
    await _dataSource.declineFriendRequest(requestId);
  }

  @override
  Future<List<FriendModel>> getCurrentUserFriends(String userId) async {
    return await _dataSource.getCurrentUserFriends(userId);
  }

  @override
  Future<List<FriendModel>> getPendingFriendRequests(String userId) async {
    return await _dataSource.getPendingFriendRequests(userId);
  }
}
