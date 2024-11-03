import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MessageModel {
  final String? id;
  final String? senderEmail;
  final String? recipientEmail;
  final String? content;
  // final String? type;
  // final String? status;
  final DateTime? createdAt;
  // final DateTime? updatedAt;

  const MessageModel({
    this.id,
    this.senderEmail,
    this.recipientEmail,
    this.content,
    // this.type,
    // this.status,
    this.createdAt,
    // this.updatedAt,
  });

  MessageModel copyWith({
    String? id,
    String? senderEmail,
    String? recipientEmail,
    String? content,
    // String? type,
    // String? status,
    DateTime? createdAt,
    // DateTime? updatedAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderEmail: senderEmail ?? this.senderEmail,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      content: content ?? this.content,
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