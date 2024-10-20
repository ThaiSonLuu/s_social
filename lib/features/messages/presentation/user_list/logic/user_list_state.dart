import 'package:equatable/equatable.dart';

import '../../../../../core/domain/model/user_model.dart';

class UserListState extends Equatable {
  const UserListState();

  @override
  List<Object?> get props => [];
}

final class UserListInitial extends UserListState {}

final class UserListLoading extends UserListState {}

final class UserListLoaded extends UserListState {
  const UserListLoaded(this.users);

  final List<Map<String, dynamic>> users;

  @override
  List<Object?> get props => [users];
}

final class UserListError extends UserListState {
  const UserListError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}