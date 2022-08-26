import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shmr/core/setup_locator.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/service/navigation/awesome_router_delegate.dart';
import 'package:shmr/service/navigation/constants.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';
import 'package:shmr/view/theme/theme_cubit.dart';
import 'package:uni_links/uni_links.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    required this.importanceColor,
    super.key,
  });

  final Color importanceColor;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<String?>? _streamSubscription;
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = locator<HomeCubit>();
    handleInitialDeepLink();
    handleIncomingLinks();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> handleInitialDeepLink() async {
    final link = await getInitialLink();
    if (link != null) {
      logger.i('Got initial link: $link');
      if (taskPageRegExp.hasMatch(link)) {
        await _homeCubit.navigateToTaskPage();
      }
    }
  }

  void handleIncomingLinks() {
    _streamSubscription = linkStream.listen(
      (link) async {
        logger.i('Got incoming link: $link');
        if (mounted && link != null && taskPageRegExp.hasMatch(link)) {
          await _homeCubit.navigateToTaskPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(
        importanceColor: widget.importanceColor,
      ),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: state,
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
          );
        },
      ),
    );
  }
}
