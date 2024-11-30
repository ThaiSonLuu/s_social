import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/domain/repository/upload_file_repository.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';
import 'package:s_social/generated/l10n.dart';

part 'edit_user_profile_state.dart';

class EditUserProfileCubit extends Cubit<EditUserProfileState> {
  EditUserProfileCubit({
    required UserRepository userRepository,
    required UploadFileRepository uploadFileRepository,
    required String? uid,
  })  : _userRepository = userRepository,
        _uploadFileRepository = uploadFileRepository,
        _uid = uid,
        super(EditUserProfileInitial());

  final UserRepository _userRepository;
  final UploadFileRepository _uploadFileRepository;
  final String? _uid;

  Future<void> getUserInfoByUid() async {
    try {
      emit(EditUserProfileLoading());

      if (_uid == null) {
        emit(EditUserProfileError(S.current.an_error_occur));
        return;
      }

      final user = await _userRepository.getUserById(_uid);
      if (user == null) {
        emit(EditUserProfileError(S.current.an_error_occur));
        return;
      }

      emit(EditUserProfileLoaded(user));
    } catch (e) {
      emit(EditUserProfileError(e.toString()));
    }
  }

  Future<String?> updateUser({
    File? backgroundImage,
    File? avatarImage,
    required UserModel user,
  }) async {
    try {
      if (_uid == null) {
        return S.current.an_error_occur;
      }

      if (backgroundImage != null) {
        final backgroundUrl =
            await _uploadFileRepository.postFile(backgroundImage);
        user = user.copyWith(backgroundUrl: backgroundUrl);
      }

      if (avatarImage != null) {
        final avatarUrl = await _uploadFileRepository.postFile(avatarImage);
        user = user.copyWith(avatarUrl: avatarUrl);
      }

      final result = await _userRepository.updateUser(user);
      if (result == null) {
        return S.current.an_error_occur;
      }

      return null;
    } catch (e) {
      return S.current.an_error_occur;
    }
  }
}
