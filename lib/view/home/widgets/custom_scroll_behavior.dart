import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shmr/service/shared_provider.dart';

class CustomScrollBehavior extends ScrollBehavior {
  CustomScrollBehavior() : super();

  final androidSdkVersion = SharedProvider.getAndroidSdkVersionInt();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (Platform.isAndroid) {
      if (androidSdkVersion > 30) {
        return StretchingOverscrollIndicator(
          axisDirection: details.direction,
          child: child,
        );
      } else {
        return GlowingOverscrollIndicator(
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          child: child,
        );
      }
    } else {
      return child;
    }
  }
}
