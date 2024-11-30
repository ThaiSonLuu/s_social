import 'package:s_social/core/data/data_source/user_service.dart';
import 'package:s_social/core/domain/model/user_model.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserDataSource userDataSource})
      : _userDataSource = userDataSource;

  final UserDataSource _userDataSource;

  @override
  Future<UserModel?> createUser(UserModel user) async {
    try {
      return await _userDataSource.createUser(user);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    try {
      return await _userDataSource.getUserById(id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<UserModel>?> getUsersByIds(List<String> ids) async {
    try {
      return await _userDataSource.getUsersByIds(ids);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel?> updateUser(UserModel user) async {
    try {
      return await _userDataSource.updateUser(user);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel?> deleteUser(UserModel user) async {
    try {
      return await _userDataSource.deleteUser(user);
    } catch (_) {
      return null;
    }
  }
}
