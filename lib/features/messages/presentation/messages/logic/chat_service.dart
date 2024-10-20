import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:s_social/common/app_constants/firestore_collection_constants.dart';

class ChatService {
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

  // send message

  // get message
}