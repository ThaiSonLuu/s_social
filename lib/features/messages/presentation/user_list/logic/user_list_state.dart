import 'package:equatable/equatable.dart';
import 'package:s_social/core/domain/model/message_model.dart';

import '../../../../../core/domain/model/user_model.dart';

class UserListState {
  const UserListState();

  List<Object?> get props => [];
}

final class UserListInitial extends UserListState {}

final class UserListLoading extends UserListState {}

final class UserListLoaded extends UserListState {
  const UserListLoaded(this.userChatMap);

  final Map<UserModel, MessageModel?> userChatMap;

  @override
  List<Object?> get props => [userChatMap];
}

final class UserListUpdated extends UserListState {
  const UserListUpdated(this.userChatMap);

  final Map<UserModel, MessageModel?> userChatMap;

  @override
  List<Object?> get props => [userChatMap];
}

final class UserListError extends UserListState {
  const UserListError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}