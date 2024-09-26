// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      signInType: $enumDecodeNullable(_$SignInTypeEnumMap, json['signInType']),
      id: json['id'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      backgroundUrl: json['backgroundUrl'] as String?,
      bio: json['bio'] as String?,
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'signInType': _$SignInTypeEnumMap[instance.signInType],
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'backgroundUrl': instance.backgroundUrl,
      'bio': instance.bio,
      'fcmTokens': instance.fcmTokens,
    };

const _$SignInTypeEnumMap = {
  SignInType.emailAndPassword: 'EMAIL_AND_PASSWORD',
  SignInType.google: 'GOOGLE',
  SignInType.facebook: 'FACEBOOK',
};
