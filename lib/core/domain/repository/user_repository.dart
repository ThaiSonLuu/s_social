import 'package:s_social/core/domain/model/user_model.dart';

abstract interface class UserRepository {
  Future<UserModel?> createUser(UserModel user);

  Future<UserModel?> getUserById(String id);

  Future<List<UserModel>?> getUsersByIds(List<String> ids);

  Future<UserModel?> updateUser(UserModel user);

  Future<UserModel?> deleteUser(UserModel user);
}
