import 'package:json_annotation/json_annotation.dart';

part 'friend_model.g.dart';

@JsonSerializable()
class FriendModel {
  final String id;
  final String senderId;
  final String receiverId;
  final DateTime dateTimeSent;
  final DateTime? dateTimeResponded;
  final FriendState state;

  FriendModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.dateTimeSent,
    this.dateTimeResponded,
    required this.state,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendModelToJson(this);
}

// State of a friend request
enum FriendState { pending, accepted, declined }

class FriendStatusModel {
  final String id;
  final FriendStatus status;

  FriendStatusModel({
    required this.id,
    required this.status,
  });
}

// Friend status between two peoples
enum FriendStatus {
  notExist, // Don't exist in DB
  needResponse, // They sent for current user
  waiting, // Current user sent to them
  friend, // They are friend
}
