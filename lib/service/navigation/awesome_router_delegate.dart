import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr/core/bootstrap.dart';
import 'package:shmr/service/navigation/constants.dart';
import 'package:shmr/service/navigation/navigation_service.dart';

class AwesomeRouterDelegate extends RouterDelegate<RouteDef>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteDef> {
  AwesomeRouterDelegate() {
    navigationService.addListener(notifyListeners);
  }
  final NavigationService navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationService>.value(
      value: navigationService,
      child: Consumer<NavigationService>(
        builder: (context, navigationService, child) {
          return Navigator(
            key: navigatorKey,
            onPopPage: _onPopPage,
            pages: List.of(navigationService.pageDefs.map((e) => e.page)),
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
    navigationService.didPop(result);
    return true;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => navigationService.navigatorKey;

  @override
  Future<void> setNewRoutePath(RouteDef configuration) async {
    await navigationService.setNewRoutePath(configuration);
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
