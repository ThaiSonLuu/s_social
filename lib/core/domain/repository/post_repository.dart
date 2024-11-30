import 'package:s_social/core/domain/model/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>?> getPosts({String? userId});

  Future<PostModel?> createPost(PostModel post);

  Future<PostModel?> deletePost(PostModel post);
}
