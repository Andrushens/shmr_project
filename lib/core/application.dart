import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shmr/data/repository/tasks_repository.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';
import 'package:shmr/view/home/home_page.dart';

class MyApp extends StatelessWidget {
  final TasksRepository tasksRepository;
  final Color importanceColor;

  const MyApp({
    required this.importanceColor,
    required this.tasksRepository,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: tasksRepository,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: Const.themeData.copyWith(
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
        home: BlocProvider(
          create: (context) => HomeCubit(
            tasksRepository: context.read<TasksRepository>(),
          ),
          child: const HomePage(),
        ),
      ),
    );
  }
}
