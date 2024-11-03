import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/core/domain/model/chat_session_model.dart';
import 'package:s_social/core/domain/model/message_model.dart';

abstract interface class ChatRepository {
  Future<ChatSessionModel?> createChatSession(ChatSessionModel chatSession);
  Future<ChatSessionModel?> getChatSession(String chatId);
  Future<void> sendMessage(String chatId, MessageModel message);
  Stream<QuerySnapshot> getMessages(String chatId);
}