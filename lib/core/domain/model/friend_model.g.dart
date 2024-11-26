// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) => FriendModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      dateTimeSent: DateTime.parse(json['dateTimeSent'] as String),
      dateTimeResponded: json['dateTimeResponded'] == null
          ? null
          : DateTime.parse(json['dateTimeResponded'] as String),
      state: $enumDecode(_$FriendStateEnumMap, json['state']),
    );

Map<String, dynamic> _$FriendModelToJson(FriendModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'dateTimeSent': instance.dateTimeSent.toIso8601String(),
      'dateTimeResponded': instance.dateTimeResponded?.toIso8601String(),
      'state': _$FriendStateEnumMap[instance.state]!,
    };

const _$FriendStateEnumMap = {
  FriendState.pending: 'pending',
  FriendState.accepted: 'accepted',
  FriendState.declined: 'declined',
};
