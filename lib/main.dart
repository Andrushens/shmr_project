import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:shmr/core/application.dart';
import 'package:shmr/core/bootstrap.dart';
import 'package:shmr/service/database_service.dart';
import 'package:shmr/utils/color_extension.dart';
import 'package:shmr/utils/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () {},
    (error, stack) {},
  );

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ),
  );
  await remoteConfig.setDefaults(
    {
      ConstStyles.importanceColorFBField: ConstStyles.kRed.toHex(),
    },
  );
  try {
    await remoteConfig.fetchAndActivate();
  } catch (_) {}
  final colorString = remoteConfig.getString(
    ConstStyles.importanceColorFBField,
  );
  final importanceColor = ColorEx.fromHex(colorString);

  await DatabaseSrvice.init();

  bootstrap();

  runApp(
    MyApp(
      importanceColor: importanceColor,
    ),
  );
}
