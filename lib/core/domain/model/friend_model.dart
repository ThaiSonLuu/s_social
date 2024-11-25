import 'package:json_annotation/json_annotation.dart';

part 'friend_model.g.dart';

@JsonSerializable()
class FriendModel {
  final String? id; // Unique identifier for the friend request
  final String senderId; // User ID of the sender
  final String receiverId; // User ID of the receiver
  final DateTime dateTimeSent; // Timestamp when the request was sent
  final DateTime? dateTimeAccepted; // Timestamp when the request was accepted
  final DateTime? dateTimeDeclined; // Timestamp when the request was declined

  FriendModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.dateTimeSent,
    this.dateTimeAccepted,
    this.dateTimeDeclined,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendModelToJson(this);

  FriendModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    DateTime? dateTimeSent,
    DateTime? dateTimeAccepted,
    DateTime? dateTimeDeclined,
  }) =>
      FriendModel(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        dateTimeSent: dateTimeSent ?? this.dateTimeSent,
        dateTimeAccepted: dateTimeAccepted ?? this.dateTimeAccepted,
        dateTimeDeclined: dateTimeDeclined ?? this.dateTimeDeclined,
      );
}
