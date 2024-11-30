// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionModel _$ReactionModelFromJson(Map<String, dynamic> json) =>
    ReactionModel(
      userId: json['userId'] as String?,
      targetId: json['targetId'] as String?,
      targetType: json['targetType'] as String?,
      reactionType: json['reactionType'] as String?,
      isReaction: json['isReaction'] as bool?,
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
    );

Map<String, dynamic> _$ReactionModelToJson(ReactionModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'targetId': instance.targetId,
      'targetType': instance.targetType,
      'reactionType': instance.reactionType,
      'isReaction': instance.isReaction,
      'updateTime': instance.updateTime?.toIso8601String(),
    };
