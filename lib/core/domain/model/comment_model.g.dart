// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: json['id'] as String?,
      postId: json['postId'] as String?,
      userId: json['userId'] as String?,
      commentText: json['commentText'] as String?,
      commentImg: json['commentImg'] as String?,
      replyComment: (json['replyComment'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'commentText': instance.commentText,
      'commentImg': instance.commentImg,
      'replyComment': instance.replyComment,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
