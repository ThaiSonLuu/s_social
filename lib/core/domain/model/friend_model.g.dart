// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) => FriendModel(
      id: json['id'] as String?,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      dateTimeSent: DateTime.parse(json['dateTimeSent'] as String),
      dateTimeAccepted: json['dateTimeAccepted'] == null
          ? null
          : DateTime.parse(json['dateTimeAccepted'] as String),
      dateTimeDeclined: json['dateTimeDeclined'] == null
          ? null
          : DateTime.parse(json['dateTimeDeclined'] as String),
    );

Map<String, dynamic> _$FriendModelToJson(FriendModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'dateTimeSent': instance.dateTimeSent.toIso8601String(),
      'dateTimeAccepted': instance.dateTimeAccepted?.toIso8601String(),
      'dateTimeDeclined': instance.dateTimeDeclined?.toIso8601String(),
    };
