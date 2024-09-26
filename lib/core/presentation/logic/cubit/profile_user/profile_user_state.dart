part of 'profile_user_cubit.dart';

sealed class ProfileUserState extends Equatable {
  const ProfileUserState();

  @override
  List<Object> get props => [];
}

final class ProfileUserInitial extends ProfileUserState {}

final class ProfileUserLoading extends ProfileUserState {}

final class ProfileUserLoaded extends ProfileUserState {
  const ProfileUserLoaded(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

final class ProfileUserError extends ProfileUserState {
  const ProfileUserError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}


