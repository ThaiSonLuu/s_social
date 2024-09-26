import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';
import 'package:s_social/generated/l10n.dart';

part 'profile_user_state.dart';

class ProfileUserCubit extends Cubit<ProfileUserState> {
  ProfileUserCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProfileUserInitial());

  final UserRepository _userRepository;

  Future<void> getUserInfo() async {
    try {
      emit(ProfileUserLoading());

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
    } catch (e) {
      emit(ProfileUserError(e.toString()));
    }
  }
}
