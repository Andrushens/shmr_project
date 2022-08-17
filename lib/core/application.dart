import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/service/navigation/awesome_router_delegate.dart';
import 'package:shmr/utils/const.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    required this.importanceColor,
    required this.tasksRepository,
    super.key,
  });

  final TasksRepository tasksRepository;
  final Color importanceColor;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: tasksRepository,
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ConstStyles.themeData.copyWith(
          errorColor: importanceColor,
          unselectedWidgetColor: importanceColor,
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'),
          // Locale('en', 'US'),
        ],
        routeInformationParser: AwesomeRouteInformationParser(),
        routerDelegate: AwesomeRouterDelegate(),
      ),
    );
  }
}
