import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String? id;
  final String? uid;
  final String? fcmToken;
  final String? imageUrl;
  final String? title;
  final String? message;
  final DateTime? time;
  final String? route;
  final bool read;

  NotificationModel({
    this.id,
    required this.uid,
    required this.fcmToken,
    required this.imageUrl,
    required this.title,
    required this.message,
    required this.time,
    required this.route,
    this.read = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? uid,
    String? fcmToken,
    String? imageUrl,
    String? title,
    String? message,
    DateTime? time,
    String? route,
    bool? read,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        fcmToken: fcmToken ?? this.fcmToken,
        imageUrl: imageUrl ?? this.imageUrl,
        title: title ?? this.title,
        message: message ?? this.message,
        time: time ?? this.time,
        route: route ?? this.route,
        read: read ?? this.read,
      );
}
