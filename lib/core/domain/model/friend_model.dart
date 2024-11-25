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

enum FriendState { pending, accepted, declined }
