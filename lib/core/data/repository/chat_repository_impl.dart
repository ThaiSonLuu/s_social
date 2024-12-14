import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/core/data/data_source/chat_data_source.dart';
import 'package:s_social/core/domain/model/chat_session_model.dart';
import 'package:s_social/core/domain/model/message_model.dart';
import 'package:timeago/timeago.dart';

import '../../domain/model/user_model.dart';
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

  @override
  Stream<QuerySnapshot> getMessageStream(String chatId) {
    try {
      return _chatDataSource.getMessageStream(chatId);
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<void> deleteMessage(String? messageId, String chatId) {
    try {
      return _chatDataSource.deleteMessage(messageId, chatId);
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<void> createUserChatMap(String userId, Map<String, MessageModel?> userChatMap) {
    try {
      return _chatDataSource.createUserChatMap(userId, userChatMap);
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, MessageModel?>?> getUserChatMap(String userId) {
    try {
      return _chatDataSource.getUserChatMap(userId);
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Map<String, MessageModel?>?> updateUserChatMap(String userId, String recipientId, MessageModel message) {
    try {
      return _chatDataSource.updateUserChatMap(userId, recipientId, message);
    } catch (_) {
      throw Exception();
    }
  }
}