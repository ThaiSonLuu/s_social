import 'package:equatable/equatable.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/model/user_model.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<ShowPost> posts;

  PostLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class ShowPost {
  final UserModel? user;
  final PostModel post;

  ShowPost({
    required this.user,
    required this.post,
  });
}

class PostError extends PostState {
  final String message;

  PostError(this.message);

  @override
  List<Object?> get props => [message];
}
