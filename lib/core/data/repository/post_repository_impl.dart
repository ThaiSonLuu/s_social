import 'package:s_social/core/data/data_source/post_service.dart';
import 'package:s_social/core/domain/model/post_model.dart';
import 'package:s_social/core/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({required PostDataSource postDataSource})
      : _postDataSource = postDataSource;

  final PostDataSource _postDataSource;

  @override
  Future<List<PostModel>?> getPosts({String? userId}) async {
    try {
      return await _postDataSource.getPosts(userId: userId);
    } catch (e) {
      print('Error getting posts: $e');
      return null;
    }
  }



  @override
  Future<PostModel?> createPost(PostModel post) async {
    try {
      return await _postDataSource.createPost(post);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<PostModel?> deletePost(PostModel post) async {
    try {
      return await _postDataSource.deletePost(post);
    } catch (_) {
      return null;
    }
  }
}
