import 'package:shmr/utils/failure.dart';

class Routes {
  static const String homePage = '/';
  static const String taskPage = '/task-view';
}

class RouteDef {
  const RouteDef(
    this.path, {
    this.data,
  });

  final dynamic data;
  final String path;
}

RouteDef parseRoute(String? location) {
  switch (location) {
    case Routes.homePage:
      return const RouteDef(Routes.homePage);
    case Routes.taskPage:
      return const RouteDef(Routes.taskPage);
  }
  throw RouteNotExistsException();
}
