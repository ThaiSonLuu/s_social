import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/generated/l10n.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  static const minPasswordLength = 6;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ChangePasswordLoading());

    if (firebaseAuth.currentUser?.email == null) {
      emit(ChangePasswordInitial());
      return;
    }

    final credential = EmailAuthProvider.credential(
      email: firebaseAuth.currentUser!.email!,
      password: oldPassword,
    );

    try {
      await firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
    } catch (e) {
      emit(ChangePasswordError(S.current.old_password_invalid));
      return;
    }

    if (newPassword.length < minPasswordLength) {
      emit(
        ChangePasswordError(
          S.current.the_password_must_be_longer_than(minPasswordLength),
        ),
      );
      return;
    }

    if (confirmPassword != newPassword) {
      emit(
        ChangePasswordError(S.current.passwords_do_not_match),
      );
      return;
    }

    try {
      await firebaseAuth.currentUser!.updatePassword(newPassword);
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordError(e.toString()));
    }
  }
}
