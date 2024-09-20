part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState(this.isLoggedIn);

  final bool isLoggedIn;

  @override
  List<Object?> get props => [isLoggedIn];
}
