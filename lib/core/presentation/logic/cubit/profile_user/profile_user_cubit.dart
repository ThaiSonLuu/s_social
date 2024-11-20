import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/notification_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/domain/repository/notification_repository.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/generated/l10n.dart';

part 'profile_user_state.dart';

class ProfileUserCubit extends Cubit<ProfileUserState> {
  ProfileUserCubit({
    required UserRepository userRepository,
    required NotificationRepository notificationRepository,
  })  : _userRepository = userRepository,
        _notificationRepository = notificationRepository,
        super(ProfileUserInitial());

  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;

  Future<void> getUserInfo() async {
    try {
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid == null) {
        return;
      }

      final user = await _userRepository.getUserById(currentUid);
      if (user == null) {
        emit(ProfileUserError(S.current.an_error_occur));
        return;
      }

      emit(ProfileUserLoaded(user));

      if (user.avatarUrl == null) {
        await _notificationRepository.createNotification(
          NotificationModel(
            uid: user.id,
            fcmToken: user.fcmTokens?.first ?? "",
            imageUrl: null,
            title: S.current.update_information,
            message: S.current.update_avatar_and_other_information,
            time: DateTime.now(),
            route: "${RouterUri.editProfile}/${user.id}",
          ),
        );
      }
    } catch (e) {
      emit(ProfileUserError(e.toString()));
    }
  }

  void removeUserInfo() {
    emit(ProfileUserInitial());
  }

  /// Get current user logged in
  /// Return null if no user logged in
  UserModel? get currentUser {
    if (state is ProfileUserLoaded) {
      return (state as ProfileUserLoaded).user;
    }

    return null;
  }
}
