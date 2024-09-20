part of 'sign_up_cubit.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {
  final bool isEmailConfirmed;

  const SignUpInitial(this.isEmailConfirmed);

  @override
  List<Object> get props => [isEmailConfirmed];
}

final class SignUpLoading extends SignUpState {}

final class SignUpLoaded extends SignUpState {
  final User user;

  const SignUpLoaded(this.user);
}

final class SignUpError extends SignUpState {
  final String error;

  const SignUpError(this.error);

  @override
  List<Object> get props => [error];
}
