import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/core/domain/model/chat_session_model.dart';
import 'package:s_social/core/domain/model/message_model.dart';

import '../model/user_model.dart';

abstract interface class ChatRepository {
  Future<ChatSessionModel?> createChatSession(ChatSessionModel chatSession);
  Future<ChatSessionModel?> getChatSession(String chatId);
  Future<void> sendMessage(String chatId, MessageModel message);
  Stream<QuerySnapshot> getMessageStream(String chatId);
  Future<void> deleteMessage(String? messageId, String chatId);

  Future<void> createUserChatMap(String userId, Map<String, MessageModel?> userChatMap);
  Future<Map<String, MessageModel?>?> getUserChatMap(String userId);
  Future<Map<String, MessageModel?>?> updateUserChatMap(String userId, String recipientId, MessageModel message);
}