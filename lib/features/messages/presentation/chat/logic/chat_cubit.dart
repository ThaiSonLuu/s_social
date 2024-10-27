import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/message_model.dart';

import '../../../../../core/domain/model/chat_session_model.dart';
import '../../../../../core/domain/repository/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required ChatRepository chatRepository}) :
        _chatRepository = chatRepository,
        super(ChatInitial());

  final ChatRepository _chatRepository;

  Future<void> getChatSession(String chatId) async {
    emit(ChatLoading());
    try {
      ChatSessionModel? chatSession = await _chatRepository.getChatSession(chatId);
      if (chatSession == null) {
        await _chatRepository.createChatSession(ChatSessionModel(chatId: chatId, messages: []));
        chatSession = await _chatRepository.getChatSession(chatId);
      }
      emit(ChatLoaded(chatSession!));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    emit(ChatLoading());
    try {
      await _chatRepository.sendMessage(chatId, message);
      final chatSession = await _chatRepository.getChatSession(chatId);
      emit(ChatLoaded(chatSession!));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}