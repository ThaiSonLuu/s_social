import 'package:json_annotation/json_annotation.dart';
import 'package:s_social/core/domain/model/message_model.dart';

part 'chat_session_model.g.dart';

@JsonSerializable()
class ChatSessionModel {
  late final String chatId;
  late final List<MessageModel> messages;

  ChatSessionModel({
    required this.chatId,
    required this.messages,
  });

  ChatSessionModel copyWith({
    String? chatId,
    List<MessageModel>? messages,
  }) {
    return ChatSessionModel(
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
    );
  }

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionModelToJson(this);
}