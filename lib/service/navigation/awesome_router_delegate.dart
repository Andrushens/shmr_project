import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr/service/navigation/constants.dart';
import 'package:shmr/service/navigation/navigation_service.dart';

class AwesomeRouterDelegate extends RouterDelegate<RouteDef>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteDef> {
  AwesomeRouterDelegate() {
    pageManager.addListener(notifyListeners);
  }
  final NavigationService pageManager = NavigationService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationService>.value(
      value: pageManager,
      child: Consumer<NavigationService>(
        builder: (context, pageManager, child) {
          return Navigator(
            key: navigatorKey,
            onPopPage: _onPopPage,
            pages: List.of(pageManager.pages),
          );
        },
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    pageManager.didPop();
    return true;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => pageManager.navigatorKey;

  @override
  Future<void> setNewRoutePath(RouteDef configuration) async {
    await pageManager.setNewRoutePath(configuration);
  }
}

class AwesomeRouteInformationParser extends RouteInformationParser<RouteDef> {
  @override
  Future<RouteDef> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return parseRoute(routeInformation.location);
  }
}
