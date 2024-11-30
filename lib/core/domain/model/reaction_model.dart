import 'package:json_annotation/json_annotation.dart';

part 'reaction_model.g.dart';

@JsonSerializable()
class ReactionModel {
  final String? userId;
  final String? targetId;         // targetId: truyền Id của các collection (userId, postId, commentId, v.v)
  final String? targetType;       // targetType: loại colletion (users, posts, comments, v.v)
  final String? reactionType;     // reactionType: like, sad, wow, ...
  final bool? isReaction;
  final DateTime? updateTime;

  ReactionModel({
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.reactionType,
    required this.isReaction,
    required this.updateTime,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) =>
      _$ReactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionModelToJson(this);

  ReactionModel copyWith({
    String? userId,
    String? targetId,
    String? targetType,
    String? reactionType,
    bool? isReaction,
    DateTime? updateTime,
  }) {
    return ReactionModel(
      userId: userId ?? this.userId,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      reactionType: reactionType ?? this.reactionType,
      isReaction: isReaction ?? this.isReaction,
      updateTime: updateTime ?? this.updateTime,
    );
  }
}
