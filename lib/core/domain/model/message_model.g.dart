// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      messageId: json['messageId'] as String?,
      senderEmail: json['senderEmail'] as String?,
      recipientEmail: json['recipientEmail'] as String?,
      content: json['content'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('messageId', instance.messageId);
  writeNotNull('senderEmail', instance.senderEmail);
  writeNotNull('recipientEmail', instance.recipientEmail);
  writeNotNull('content', instance.content);
  writeNotNull('images', instance.images);
  val['createdAt'] = instance.createdAt.toIso8601String();
  return val;
}
