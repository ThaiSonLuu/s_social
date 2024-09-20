import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(false));

  void checkLogin() {
    emit(AuthState(FirebaseAuth.instance.currentUser != null));
  }

  Future<void> login() async {
    emit(const AuthState(true));
  }

  Future<void> logout() async {
    emit(const AuthState(false));
    await FirebaseAuth.instance.signOut();
  }

}
