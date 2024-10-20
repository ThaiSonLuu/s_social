import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/app_constants/firestore_collection_constants.dart';
import 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListInitial());

  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection(FirestoreCollectionConstants.users).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Go through each user
        final user = doc.data();

        // Return user
        return user;
      }).toList();
    });
  }
}