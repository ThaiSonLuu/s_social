import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/app_constants/firestore_collection_constants.dart';
import 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListInitial());

  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user list from firestore
  Future<void> getUserList() async {
    emit(UserListLoading());
    try {
      final users = await _firestore.collection(FirestoreCollectionConstants.users).get();
      final userList = users.docs.map((doc) => doc.data()).toList();
      emit(UserListLoaded(userList));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }
}