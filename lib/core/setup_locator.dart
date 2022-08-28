import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr/data/local/local_source.dart';
import 'package:shmr/data/remote/interceptors/logger_interceptor.dart';
import 'package:shmr/data/remote/interceptors/patch_interceptor.dart';
import 'package:shmr/data/remote/interceptors/revision_interceptor.dart';
import 'package:shmr/data/remote/remote_source.dart';
import 'package:shmr/domain/repository/tasks/tasks_repository.dart';
import 'package:shmr/service/analytics_provider.dart';
import 'package:shmr/service/connecitivty_status_provider.dart';
import 'package:shmr/service/local_database_service.dart';
import 'package:shmr/service/navigation/navigation_service.dart';
import 'package:shmr/service/shared_provider.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await LocalDataBaseService().database;
  final localSource = LocalSourceImpl(database);
  final connectivityProvider = ConnectivityProviderImpl();
  final firebaseAnalytics = FirebaseAnalytics.instance;
  final analyticsProvider = AnalyticsProviderImpl(firebaseAnalytics);

  final dio = Dio(
    BaseOptions(
      baseUrl: ConstRemote.baseUrl,
      headers: ConstRemote.baseHeaders,
      receiveTimeout: ConstRemote.receiveTimeout,
      sendTimeout: ConstRemote.sendTimeout,
    ),
  );
  dio.interceptors.addAll(
    [
      RevisionInterceptor(),
      LoggingInterceptor(),
      PatchInterceptor(dio, localSource),
    ],
  );
  final tasksRepository = TasksRepositoryImpl(
    remoteSource: RemoteSourceImpl(dio),
    localSource: localSource,
    connectivityProvider: connectivityProvider,
    analyticsProvider: analyticsProvider,
  );

  locator
    ..registerSingleton<SharedHelper>(SharedHelper(sharedPreferences))
    ..registerSingleton<NavigationService>(
      NavigationService(analyticsProvider),
    )
    ..registerSingleton<TasksRepository>(tasksRepository)
    ..registerSingleton<HomeCubit>(
      HomeCubit(tasksRepository: locator<TasksRepository>()),
    );
}
