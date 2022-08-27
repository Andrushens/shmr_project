import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr/data/data_source/local_source.dart';
import 'package:shmr/data/data_source/remote_source.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/service/local_database_service.dart';
import 'package:shmr/service/navigation/navigation_service.dart';
import 'package:shmr/service/shared_provider.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await LocalDataBaseService().database;

  final tasksRepository = TasksRepositoryImpl(
    remoteSource: RemoteSourceImpl(),
    localSource: LocalSourceImpl(database),
  );

  locator
    ..registerSingleton<SharedHelper>(SharedHelper(sharedPreferences))
    ..registerSingleton<NavigationService>(NavigationService())
    ..registerSingleton<HomeCubit>(HomeCubit(tasksRepository: tasksRepository));
}
