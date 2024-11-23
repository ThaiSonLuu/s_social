import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String? id;
  final String? postId;
  final String? userId;
  final String? commentText;
  final String? commentImg;
  final DateTime? createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.commentText,
    required this.commentImg,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? commentText,
    String? commentImg,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      commentText: commentText ?? this.commentText,
      commentImg: commentImg ?? this.commentImg,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
