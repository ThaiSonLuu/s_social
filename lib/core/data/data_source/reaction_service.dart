import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/model/reaction_model.dart';

class ReactionDataSource {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  String? get userId {
    final user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  // Thêm hoặc xóa phản ứng từ Firestore
  Future<void> toggleReaction(ReactionModel reaction) async {
    if (userId == null) {
      throw Exception("User not authenticated.");
    }

    final reactionDoc = _firebaseFirestore
        .collection(reaction.targetType!)
        .doc(reaction.targetId)
        .collection('reactions')
        .doc('${reaction.userId}_${reaction.reactionType}');

    if (reaction.isReaction!) {
      await reactionDoc.set(reaction.toJson());
    } else {
      await reactionDoc.update(reaction.toJson());
      await reactionDoc.delete();
    }
  }

  // Kiểm tra xem người dùng đã thực hiện phản ứng hay chưa
  Future<bool> checkUserReacted(String targetId, String targetType, String reactionType) async {
    if (userId == null) {
      throw Exception("User not authenticated.");
    }

    final reactionDoc = await _firebaseFirestore
        .collection(targetType)
        .doc(targetId)
        .collection('reactions')
        .doc('${userId}_$reactionType')
        .get();

    return reactionDoc.exists;
  }

  // Đếm số lượng phản ứng từ Firestore
  Future<int> countReactions(String targetId, String targetType) async {
    final reactionsSnapshot = await _firebaseFirestore
        .collection(targetType)
        .doc(targetId)
        .collection('reactions')
        .where('isReaction', isEqualTo: true)
        .get();

    return reactionsSnapshot.size;
  }
}
