import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr/model/task/task.dart';
import 'package:shmr/service/navigation/constants.dart';
import 'package:shmr/view/home/home_page.dart';
import 'package:shmr/view/task/task_page.dart';

class NavigationService extends ChangeNotifier {
  static NavigationService of(BuildContext context) {
    return Provider.of<NavigationService>(context, listen: false);
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<Page<dynamic>> get pages => List.unmodifiable(_pages);
  final List<Page<dynamic>> _pages = [
    const MaterialPage(
      child: HomePage(),
      name: Routes.homePage,
    ),
  ];

  void didPop() {
    _pages.removeLast();
    notifyListeners();
  }

  Future<void> setNewRoutePath(RouteDef routeDef) async {
    switch (routeDef.path) {
      case Routes.homePage:
        _pages.removeWhere((e) => e.name != Routes.homePage);
        break;
      case Routes.taskPage:
        _pages.add(
          MaterialPage(
            child: TaskPage(
              task: routeDef.data as Task?,
            ),
            name: Routes.taskPage,
            key: UniqueKey(),
          ),
        );
        break;
      default:
        _pages.removeLast();
    }
    notifyListeners();
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

  void back() {
    _pages.removeLast();
    notifyListeners();
  }
}
