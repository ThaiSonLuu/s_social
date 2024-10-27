import 'package:s_social/core/data/data_source/chat_data_source.dart';
import 'package:s_social/core/domain/model/chat_session_model.dart';
import 'package:s_social/core/domain/model/message_model.dart';

import '../../domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required ChatDataSource chatDataSource})
      : _chatDataSource = chatDataSource;

  final ChatDataSource _chatDataSource;

  @override
  Future<ChatSessionModel?> createChatSession(ChatSessionModel chatSession) {
    try {
      return _chatDataSource.createChatSession(chatSession);
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<ChatSessionModel?> getChatSession(String chatId) {
    try {
      return _chatDataSource.getChatSession(chatId);
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<void> sendMessage(String chatId, MessageModel message) {
    try {
      return _chatDataSource.sendMessage(chatId, message);
    } catch (_) {
      throw Exception();
    }
  }
}