import 'package:get_it/get_it.dart';
import 'package:shmr/data/data_source/local_source.dart';
import 'package:shmr/data/data_source/remote_source.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/service/navigation/navigation_service.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';

final locator = GetIt.instance;

void bootstrap() {
  final tasksRepository = TasksRepositoryImpl(
    remoteSource: RemoteSourceImpl(),
    localSource: LocalSourceImpl(),
  );

  locator
    ..registerSingleton<NavigationService>(NavigationService())
    ..registerSingleton<HomeCubit>(HomeCubit(tasksRepository: tasksRepository));
}
