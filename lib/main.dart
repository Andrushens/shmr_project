import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shmr/bloc/task/task_cubit.dart';
import 'package:shmr/generated/l10n.dart';
import 'package:shmr/service/database_provider.dart';
import 'package:shmr/utils/const.dart';
import 'package:shmr/view/home/home_page.dart';
import 'package:shmr/utils/color_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  var remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ),
  );
  await remoteConfig.setDefaults(
    {
      'importance_color': Const.kRed.toHex(),
    },
  );
  try {
    await remoteConfig.fetchAndActivate();
  } catch (_) {}
  var colorString = remoteConfig.getString('importance_color');
  var importanceColor = ColorEx.fromHex(colorString);

  await DatabaseProvider.init();

  runApp(
    MyApp(
      importanceColor: importanceColor,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Color importanceColor;

  const MyApp({
    required this.importanceColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Const.themeData.copyWith(
        errorColor: importanceColor,
        unselectedWidgetColor: importanceColor,
      ),
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
      home: BlocProvider(
        create: (context) => TaskCubit(),
        child: const HomePage(),
      ),
    );
  }
}
