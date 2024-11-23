// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      fcmToken: json['fcmToken'] as String?,
      imageUrl: json['imageUrl'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      route: json['route'] as String?,
      read: json['read'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'fcmToken': instance.fcmToken,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'message': instance.message,
      'time': instance.time?.toIso8601String(),
      'route': instance.route,
      'read': instance.read,
    };
