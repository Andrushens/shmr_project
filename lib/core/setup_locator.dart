import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr/data/data_source/local_source.dart';
import 'package:shmr/data/data_source/remote_source.dart';
import 'package:shmr/domain/repository/tasks_repository.dart';
import 'package:shmr/service/analytics_provider.dart';
import 'package:shmr/service/connecitivty_status_provider.dart';
import 'package:shmr/service/local_database_service.dart';
import 'package:shmr/service/navigation/navigation_service.dart';
import 'package:shmr/service/shared_provider.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = await LocalDataBaseService().database;
  final connectivityProvider = ConnectivityProviderImpl();
  final firebaseAnalytics = FirebaseAnalytics.instance;
  final analyticsProvider = AnalyticsProviderImpl(firebaseAnalytics);
  final tasksRepository = TasksRepositoryImpl(
    remoteSource: RemoteSourceImpl(),
    localSource: LocalSourceImpl(database),
    connectivityProvider: connectivityProvider,
    analyticsProvider: analyticsProvider,
  );

  locator
    ..registerSingleton<SharedHelper>(SharedHelper(sharedPreferences))
    ..registerSingleton<NavigationService>(
      NavigationService(analyticsProvider),
    )
    ..registerSingleton<HomeCubit>(
      HomeCubit(tasksRepository: tasksRepository),
    );
}
