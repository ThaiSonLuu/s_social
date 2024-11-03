part of 'edit_user_profile_cubit.dart';

sealed class EditUserProfileState extends Equatable {
  const EditUserProfileState();

  @override
  List<Object> get props => [];
}

final class EditUserProfileInitial extends EditUserProfileState {}

final class EditUserProfileLoading extends EditUserProfileState {}

final class EditUserProfileLoaded extends EditUserProfileState {
  const EditUserProfileLoaded(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

final class EditUserProfileUpdating extends EditUserProfileState {}

final class EditUserProfileUpdated extends EditUserProfileState {
  const EditUserProfileUpdated(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

final class EditUserProfileError extends EditUserProfileState {
  const EditUserProfileError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
