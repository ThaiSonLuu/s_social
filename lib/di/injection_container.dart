import 'package:get_it/get_it.dart';
import 'package:s_social/core/data/data_source/comment_service.dart';
import 'package:s_social/core/data/data_source/post_service.dart';
import 'package:s_social/core/data/data_source/user_service.dart';
import 'package:s_social/core/data/repository/comment_repository_impl.dart';
import 'package:s_social/core/data/repository/post_repository_impl.dart';
import 'package:s_social/core/data/repository/user_repository_impl.dart';
import 'package:s_social/core/domain/repository/comment_repository.dart';
import 'package:s_social/core/domain/repository/post_repository.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  // DataSource
  serviceLocator.registerLazySingleton(() => UserDataSource());
  serviceLocator.registerLazySingleton(() => PostDataSource());
  serviceLocator.registerLazySingleton(() => CommentDataSource());

  // Repository
  serviceLocator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(postDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<CommentRepository>(
      () => CommentRepositoryImpl(commentDataSource: serviceLocator()),
  );
}
