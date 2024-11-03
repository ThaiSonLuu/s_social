part of 's_user_profile_cubit.dart';

sealed class SUserProfileState extends Equatable {
  const SUserProfileState();

  @override
  List<Object> get props => [];
}

final class SUserProfileInitial extends SUserProfileState {}

final class SUserProfileLoading extends SUserProfileState {}

final class SUserProfileLoaded extends SUserProfileState {
  const SUserProfileLoaded(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

final class SUserProfileError extends SUserProfileState {
  const SUserProfileError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
