import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shmr/model/failure.dart';

class Routes {
  static const String homePage = '/';
  static const String taskPage = '/task-page';
}

final taskPageRegExp = RegExp('${Routes.taskPage}\$');

class PageDef {
  const PageDef({
    required this.page,
    required this.completer,
  });

  final Page<dynamic> page;
  final Completer<dynamic> completer;
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
