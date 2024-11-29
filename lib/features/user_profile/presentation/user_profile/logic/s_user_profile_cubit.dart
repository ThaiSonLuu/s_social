import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';
import 'package:s_social/generated/l10n.dart';

part 's_user_profile_state.dart';

class SUserProfileCubit extends Cubit<SUserProfileState> {
  SUserProfileCubit({
    required UserRepository userRepository,
    required String? uid,
  })  : _userRepository = userRepository,
        _uid = uid,
        super(SUserProfileInitial());

  final UserRepository _userRepository;
  final String? _uid;

  Future<void> getUserInfoByUid() async {
    try {
      emit(SUserProfileLoading());

      if (_uid == null) {
        emit(SUserProfileError(S.current.an_error_occur));
        return;
      }

      final user = await _userRepository.getUserById(_uid);
      if (user == null) {
        emit(SUserProfileError(S.current.an_error_occur));
        return;
      }

      emit(SUserProfileLoaded(user));
    } catch (e) {
      emit(SUserProfileError(e.toString()));
    }
  }

  UserModel? get user {
    if (state is SUserProfileLoaded) {
      return (state as SUserProfileLoaded).user;
    }

    return null;
  }
}
