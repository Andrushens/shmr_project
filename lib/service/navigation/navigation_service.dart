import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shmr/domain/model/task/task.dart';
import 'package:shmr/service/analytics_provider.dart';
import 'package:shmr/service/navigation/constants.dart';
import 'package:shmr/view/home/home_page.dart';
import 'package:shmr/view/task/task_page.dart';

class NavigationService extends ChangeNotifier {
  NavigationService(this.analyticsprovider);

  final AnalyticsProvider analyticsprovider;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<PageDef> get pageDefs => List.unmodifiable(_pageDefs);
  final List<PageDef> _pageDefs = [
    PageDef(
      completer: Completer(),
      page: MaterialPage(
        child: const HomePage(),
        name: Routes.homePage,
        key: UniqueKey(),
      ),
    ),
  ];

  void didPop(dynamic result) {
    final page = _pageDefs.removeLast();
    page.completer.complete(result);
    notifyListeners();
  }

  Future<dynamic> setNewRoutePath(RouteDef routeDef) async {
    switch (routeDef.path) {
      case Routes.homePage:
        await analyticsprovider.logEvent(AnalyticsEvent.onHomePage);
        _pageDefs.removeWhere((e) => e.page.name != Routes.homePage);
        notifyListeners();
        break;
      case Routes.taskPage:
        await analyticsprovider.logEvent(AnalyticsEvent.onTaskPage);
        final completer = Completer<Task?>();
        final page = MaterialPage<dynamic>(
          child: TaskPage(
            task: routeDef.data as Task?,
          ),
          name: Routes.taskPage,
          key: UniqueKey(),
        );
        if (_pageDefs.last.page.name == Routes.taskPage) {
          _pageDefs.removeLast();
        }
        _pageDefs.add(
          PageDef(completer: completer, page: page),
        );
        notifyListeners();
        return completer.future;
      default:
        _pageDefs.removeLast();
        notifyListeners();
    }
  }

  Future<dynamic> navigateTo(String path, {dynamic data}) async {
    switch (path) {
      case Routes.homePage:
        return setNewRoutePath(
          const RouteDef(
            Routes.homePage,
          ),
        );
      case Routes.taskPage:
        return setNewRoutePath(
          RouteDef(
            Routes.taskPage,
            data: data,
          ),
        );
    }
  }

  void back(dynamic result) {
    didPop(result);
  }
}
