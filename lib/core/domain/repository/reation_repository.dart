import 'package:s_social/core/domain/model/reaction_model.dart';

abstract class ReactionRepository {
  Future<ReactionModel?> toggleReaction(ReactionModel reaction);
  Future<bool> checkUserReacted({
    required String targetId,
    required String targetType,
    required String reactionType,
  });
}
