import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/domain/model/reaction_model.dart';
import '../../../../core/domain/repository/reation_repository.dart';
part 'reaction_state.dart';


class ReactionCubit extends Cubit<ReactionState> {
  final ReactionRepository reactionRepository;

  ReactionCubit(
      this.reactionRepository
      ) : super(ReactionInitial());

  /// Thêm hoặc xóa phản ứng (toggle reaction)
  Future<void> toggleReaction(ReactionModel reaction) async {
    final reactionDoc = FirebaseFirestore.instance
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

  Future<bool> checkUserReacted(String targetId, String targetType, String reactionType) async {
    try {
      return await reactionRepository.checkUserReacted(
        targetId: targetId,
        targetType: targetType,
        reactionType: reactionType,
      );
    } catch (e) {
      emit(ReactionError('Failed to check user reaction: $e'));
      return false;
    }
  }

  Stream<int> countReactions(String targetId, String targetType) {
    try {
      final reactionsCollection = FirebaseFirestore.instance
          .collection(targetType)
          .doc(targetId)
          .collection('reactions');

      return reactionsCollection.snapshots().map((snapshot) {
        return snapshot.size;
      });
    } catch (e) {
      emit(ReactionError('Failed to count reactions: $e'));
      return Stream.value(0);
    }
  }
}
