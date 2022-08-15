// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My tasks`
  String get myTasks {
    return Intl.message(
      'My tasks',
      name: 'myTasks',
      desc: '',
      args: [],
    );
  }

  /// `Done - {amount}`
  String doneAmount(Object amount) {
    return Intl.message(
      'Done - $amount',
      name: 'doneAmount',
      desc: '',
      args: [amount],
    );
  }

  /// `New task`
  String get newTask {
    return Intl.message(
      'New task',
      name: 'newTask',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `What to do...`
  String get whatToDo {
    return Intl.message(
      'What to do...',
      name: 'whatToDo',
      desc: '',
      args: [],
    );
  }

  /// `Importance`
  String get importance {
    return Intl.message(
      'Importance',
      name: 'importance',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get low {
    return Intl.message(
      'Low',
      name: 'low',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get basic {
    return Intl.message(
      'No',
      name: 'basic',
      desc: '',
      args: [],
    );
  }

  /// `Important`
  String get important {
    return Intl.message(
      'Important',
      name: 'important',
      desc: '',
      args: [],
    );
  }

  /// `Complete till`
  String get completeTill {
    return Intl.message(
      'Complete till',
      name: 'completeTill',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `january`
  String get january {
    return Intl.message(
      'january',
      name: 'january',
      desc: '',
      args: [],
    );
  }

  /// `february`
  String get february {
    return Intl.message(
      'february',
      name: 'february',
      desc: '',
      args: [],
    );
  }

  /// `march`
  String get march {
    return Intl.message(
      'march',
      name: 'march',
      desc: '',
      args: [],
    );
  }

  /// `april`
  String get april {
    return Intl.message(
      'april',
      name: 'april',
      desc: '',
      args: [],
    );
  }

  /// `may`
  String get may {
    return Intl.message(
      'may',
      name: 'may',
      desc: '',
      args: [],
    );
  }

  /// `june`
  String get june {
    return Intl.message(
      'june',
      name: 'june',
      desc: '',
      args: [],
    );
  }

  /// `july`
  String get july {
    return Intl.message(
      'july',
      name: 'july',
      desc: '',
      args: [],
    );
  }

  /// `august`
  String get august {
    return Intl.message(
      'august',
      name: 'august',
      desc: '',
      args: [],
    );
  }

  /// `september`
  String get september {
    return Intl.message(
      'september',
      name: 'september',
      desc: '',
      args: [],
    );
  }

  /// `october`
  String get october {
    return Intl.message(
      'october',
      name: 'october',
      desc: '',
      args: [],
    );
  }

  /// `november`
  String get november {
    return Intl.message(
      'november',
      name: 'november',
      desc: '',
      args: [],
    );
  }

  /// `december`
  String get december {
    return Intl.message(
      'december',
      name: 'december',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
