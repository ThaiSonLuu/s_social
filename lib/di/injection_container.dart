import 'package:get_it/get_it.dart';
import 'package:s_social/core/data/data_source/user_service.dart';
import 'package:s_social/core/data/repository/user_repository_impl.dart';
import 'package:s_social/core/domain/repository/user_repository.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  // DataSource
  serviceLocator.registerLazySingleton(() => UserDataSource());

  // Repository
  serviceLocator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userDataSource: serviceLocator()),
  );
}
