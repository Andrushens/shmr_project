import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shmr/core/setup_locator.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/service/navigation/awesome_router_delegate.dart';
import 'package:shmr/service/navigation/constants.dart';
import 'package:shmr/service/navigation/navigation_service.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/cubit/home_cubit.dart';
import 'package:shmr/view/home/widgets/custom_scroll_behavior.dart';
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
  late final NavigationService _navigationService;
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = locator<HomeCubit>();
    _navigationService = locator<NavigationService>();
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
        final task = await _navigationService.navigateTo(Routes.taskPage);
        await _homeCubit.handleTaskPagePop(task);
      }
    }
  }

  void handleIncomingLinks() {
    _streamSubscription = linkStream.listen(
      (link) async {
        logger.i('Got incoming link: $link');
        if (mounted && link != null && taskPageRegExp.hasMatch(link)) {
          final task = await _navigationService.navigateTo(Routes.taskPage);
          await _homeCubit.handleTaskPagePop(task);
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
            scrollBehavior: CustomScrollBehavior(),
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
