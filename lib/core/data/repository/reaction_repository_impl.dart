import '../../domain/model/reaction_model.dart';
import '../../domain/repository/reation_repository.dart';
import '../data_source/reaction_service.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  final ReactionDataSource _reactionDataSource;

  ReactionRepositoryImpl(this._reactionDataSource);

  /// Thêm hoặc xóa phản ứng (toggle reaction)
  @override
  Future<ReactionModel?> toggleReaction(ReactionModel reaction) async {
    try {
      // Gọi DataSource để thêm hoặc xóa phản ứng
      await _reactionDataSource.toggleReaction(reaction);
      // Sau khi thực hiện toggle, trả lại đối tượng reaction
      return reaction;
    } catch (e) {
      rethrow;
    }
  }

  /// Kiểm tra xem người dùng đã phản ứng với mục tiêu cụ thể hay chưa
  @override
  Future<bool> checkUserReacted({
    required String targetId,
    required String targetType,
    required String reactionType,
  }) async {
    try {
      return await _reactionDataSource.checkUserReacted(targetId, targetType, reactionType,);
    } catch (e) {
      rethrow;
    }
  }
}
