import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String? id;

  /// If [userId] null -> Anonymous post
  final String? userId;
  final String? postContent;
  final String? postImage;
  final DateTime? createdAt;
  final int? like;

  PostModel({
    this.id,
    required this.userId,
    required this.postContent,
    required this.postImage,
    required this.createdAt,
    required this.like,
    // required this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  PostModel copyWith({
    String? id,
    String? userId,
    String? postContent,
    String? postImage,
    DateTime? createdAt,
    int? like,
    // List<String>? comments,
    bool? postAnonymous,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      postContent: postContent ?? this.postContent,
      postImage: postImage ?? this.postImage,
      createdAt: createdAt ?? this.createdAt,
      like: like ?? this.like,
      // comments: comments ?? this.comments,
    );
  }
}
