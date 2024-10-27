part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  const ChatLoaded(this.chatSession);

  final ChatSessionModel chatSession;

  @override
  List<Object?> get props => [chatSession];
}

final class ChatError extends ChatState {
  const ChatError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}