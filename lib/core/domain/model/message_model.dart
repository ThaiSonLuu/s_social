import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MessageModel {
  final String? messageId;
  final String? senderEmail;
  final String? recipientEmail;
  final String? content;
  final List<String?>? images;
  // final String? type;
  // final String? status;
  final DateTime createdAt;
  // final DateTime? updatedAt;

  const MessageModel({
    this.messageId,
    this.senderEmail,
    this.recipientEmail,
    this.content,
    this.images,
    // this.type,
    // this.status,
    required this.createdAt,
    // this.updatedAt,
  });

  MessageModel copyWith({
    String? messageId,
    String? senderEmail,
    String? recipientEmail,
    String? content,
    List<String?>? images,
    // String? type,
    // String? status,
    required DateTime createdAt,
    // DateTime? updatedAt,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderEmail: senderEmail ?? this.senderEmail,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      content: content ?? this.content,
      images: images ?? this.images,
      // type: type ?? this.type,
      // status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      // updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}