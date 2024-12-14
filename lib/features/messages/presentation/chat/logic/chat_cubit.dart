import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/message_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/domain/model/chat_session_model.dart';
import '../../../../../core/domain/model/user_model.dart';
import '../../../../../core/domain/repository/chat_repository.dart';
import '../../../../../core/domain/repository/upload_file_repository.dart';
import '../../../../../core/domain/repository/user_repository.dart';
import '../../../../../generated/l10n.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required ChatRepository chatRepository,
    required UploadFileRepository uploadFileRepository,
    required UserRepository userRepository,
    required String? uid,
  })  : _chatRepository = chatRepository,
        _uploadFileRepository = uploadFileRepository,
        _userRepository = userRepository,
        _uid = uid,
        super(ChatInitial());

  final ChatRepository _chatRepository;
  final UploadFileRepository _uploadFileRepository;
  final UserRepository _userRepository;
  final String? _uid;

  Future<void> getChatSession(String chatId) async {
    emit(ChatLoading());
    try {
      ChatSessionModel? chatSession =
        await _chatRepository.getChatSession(chatId);
      if (chatSession == null) {
        await _chatRepository.createChatSession(ChatSessionModel(
          chatId: chatId,
        ));
        chatSession = await _chatRepository.getChatSession(chatId);
      }
      emit(ChatLoaded());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
  }) async {
    try {
      await _chatRepository.sendMessage(chatId, message);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Stream<QuerySnapshot> getMessageStream(String chatId) {
    return _chatRepository.getMessageStream(chatId);
  }

  Future<void> deleteMessage(String? messageId, String chatId) async {
    try {
      await _chatRepository.deleteMessage(messageId, chatId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<List<String?>?> uploadImagesToFirebase(List<File> imageFiles) async {
    try {
      final urls = _uploadFileRepository.postMultipleFiles(imageFiles);
      return urls;
    } catch (e) {
      return null;
    }
  }
}
