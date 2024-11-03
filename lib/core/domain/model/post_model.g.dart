// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      postContent: json['postContent'] as String?,
      postImage: json['postImage'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      like: (json['like'] as num?)?.toInt(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      postAnonymous: json['postAnonymous'] as bool?,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'postContent': instance.postContent,
      'postImage': instance.postImage,
      'createdAt': instance.createdAt?.toIso8601String(),
      'like': instance.like,
      'comments': instance.comments,
      'postAnonymous': instance.postAnonymous,
    };
