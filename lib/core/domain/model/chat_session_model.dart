import 'package:json_annotation/json_annotation.dart';
import 'package:s_social/core/domain/model/message_model.dart';

part 'chat_session_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChatSessionModel {
  late final String chatId;

  ChatSessionModel({
    required this.chatId,
  });

  ChatSessionModel copyWith({
    String? chatId,
  }) {
    return ChatSessionModel(
      chatId: chatId ?? this.chatId,
    );
  }

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionModelToJson(this);
}