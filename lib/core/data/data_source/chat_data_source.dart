import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/core/domain/model/chat_session_model.dart';
import 'package:s_social/core/domain/model/message_model.dart';

import '../../../common/app_constants/firestore_collection_constants.dart';

class ChatDataSource {
  final firestoreDatabase = FirebaseFirestore.instance;

  CollectionReference get _chatCollection {
    return firestoreDatabase.collection(FirestoreCollectionConstants.chats);
  }

  Future<ChatSessionModel> createChatSession(ChatSessionModel chatSession) async {
    try {
      final saveChatSession = chatSession.copyWith(
          chatId: chatSession.chatId,
      );
      DocumentReference<dynamic> chatDoc = _chatCollection.doc(saveChatSession.chatId);
      chatDoc.set(saveChatSession.toJson());
      return saveChatSession;
    } catch (_) {
      rethrow;
    }
  }

  Future<ChatSessionModel?> getChatSession(String chatId) async {
    try {
      DocumentReference<dynamic> chatDoc = _chatCollection.doc(chatId);
      final snapShot = await chatDoc.get();
      if (snapShot.data() == null) {
        return null;
      }
      Map<String, dynamic> mapData = snapShot.data();
      final ChatSessionModel foundChat = ChatSessionModel.fromJson(mapData);
      return foundChat;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    try {
      await _chatCollection
          .doc(chatId)
          .collection(FirestoreCollectionConstants.messages)
          .doc(message.messageId)
          .set(message.toJson());
    } catch (_) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getMessageStream(String chatId) {
    return _chatCollection
        .doc(chatId)
        .collection(FirestoreCollectionConstants.messages)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> deleteMessage(String? messageId, String chatId) async {
    try {
      await _chatCollection
          .doc(chatId)
          .collection(FirestoreCollectionConstants.messages)
          .doc(messageId)
          .delete();
    } catch (_) {
      rethrow;
    }
  }
}