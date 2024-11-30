import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_social/common/app_constants/firestore_collection_constants.dart';
import 'package:s_social/core/domain/model/user_model.dart';

class UserDataSource {
  CollectionReference get _usersCollection {
    final firestoreDatabase = FirebaseFirestore.instance;
    return firestoreDatabase.collection(FirestoreCollectionConstants.users);
  }

  Future<UserModel> createUser(UserModel user) async {
    try {
      DocumentReference<dynamic> userDoc = _usersCollection.doc(user.id);
      final saveUser = user.copyWith(id: userDoc.id);
      await userDoc.set(saveUser.toJson());
      return saveUser;
    } catch (_) {
      rethrow;
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentReference<dynamic> userDoc = _usersCollection.doc(id);
      final snapShot = await userDoc.get();
      Map<String, dynamic> mapData = snapShot.data();
      final UserModel foundUser = UserModel.fromJson(mapData);
      return foundUser;
    } catch (_) {
      rethrow;
    }
  }

  Future<List<UserModel>> getUsersByIds(List<String> ids) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      List<UserModel> users = querySnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUser(UserModel user) async {
    try {
      DocumentReference<dynamic> userDoc = _usersCollection.doc(user.id);
      await userDoc.update(user.toJson());
      return user;
    } catch (_) {
      rethrow;
    }
  }

  Future<UserModel> deleteUser(UserModel user) async {
    try {
      DocumentReference<dynamic> userDoc = _usersCollection.doc(user.id);
      await userDoc.delete();
      return user;
    } catch (_) {
      rethrow;
    }
  }
}
