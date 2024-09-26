import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum SignInType {
  @JsonValue("EMAIL_AND_PASSWORD")
  emailAndPassword,
  @JsonValue("GOOGLE")
  google,
  @JsonValue("FACEBOOK")
  facebook,
}

@JsonSerializable()
class UserModel {
  final SignInType? signInType;
  final String? id;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String? backgroundUrl;
  final String? bio;
  final List<String>? fcmTokens;

  const UserModel({
    this.signInType,
    this.id,
    this.email,
    this.username,
    this.avatarUrl,
    this.backgroundUrl,
    this.bio,
    this.fcmTokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    SignInType? signInType,
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    String? backgroundUrl,
    String? bio,
    List<String>? fcmTokens,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      bio: bio ?? this.bio,
      signInType: signInType ?? this.signInType,
      fcmTokens: fcmTokens ?? this.fcmTokens,
    );
  }
}
