import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginWithAccount({
    required String email,
    required String password,
  }) async {
    try {
      emit(LoginLoading());
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        emit(const LoginError("An error occur"));
        return;
      }

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        emit(const LoginError("Please verify your account in email"));
        return;
      }

      emit(LoginLoaded());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      // Show loading after the dialog login with Google hidden
      emit(LoginLoading());

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        emit(LoginLoaded());
      } else {
        emit(const LoginError("An error occur"));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.accessToken == null) {
        emit(const LoginError("An error occur"));
        return;
      }

      // Show loading after back from login with Facebook
      emit(LoginLoading());

      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.token,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        emit(LoginLoaded());
      } else {
        emit(const LoginError("An error occur"));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
