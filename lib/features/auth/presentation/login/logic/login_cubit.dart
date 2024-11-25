import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_social/core/domain/model/notification_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/domain/repository/notification_repository.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/generated/l10n.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required UserRepository userRepository,
    required NotificationRepository notificationRepository,
  })  : _userRepository = userRepository,
        _notificationRepository = notificationRepository,
        super(LoginInitial());

  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;

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

      await _handleUserExist(
        signInType: SignInType.emailAndPassword,
        user: userCredential.user!,
      );
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

      if (userCredential.user == null) {
        emit(const LoginError("An error occur"));
        return;
      }

      await _handleUserExist(
        signInType: SignInType.google,
        user: userCredential.user!,
      );
      emit(LoginLoaded());
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

      if (userCredential.user == null) {
        emit(const LoginError("An error occur"));
        return;
      }

      await _handleUserExist(
        signInType: SignInType.facebook,
        user: userCredential.user!,
      );
      emit(LoginLoaded());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> _handleUserExist({
    required SignInType signInType,
    required User user,
  }) async {
    String? defaultUserName;
    if (user.displayName != null) {
      defaultUserName = user.displayName;
    } else {
      final splitEmail = user.email?.split("@") ?? [];
      if (splitEmail.isNotEmpty) {
        defaultUserName = splitEmail.first;
      }
    }

    defaultUserName ??= user.email;

    UserModel? foundUser = await _userRepository.getUserById(user.uid);

    // If this is the first time login
    if (foundUser == null) {
      await _userRepository.createUser(
        UserModel(
          id: user.uid,
          email: user.email,
          username: defaultUserName,
          avatarUrl: user.photoURL,
          signInType: signInType,
        ),
      );
    }

    if (foundUser == null || (foundUser.avatarUrl?.isEmpty ?? true)) {
      await _notificationRepository.createNotification(
        NotificationModel(
          uid: foundUser!.id,
          fcmToken: foundUser.fcmTokens,
          imageUrl: null,
          title: S.current.update_information,
          message: S.current.update_avatar_and_other_information,
          time: DateTime.now(),
          route: "${RouterUri.editProfile}/${foundUser.id}",
        ),
      );
    }
  }
}
