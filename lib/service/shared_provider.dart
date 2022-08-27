import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr/core/setup_locator.dart';
import 'package:shmr/utils/const.dart';

class SharedProvider {
  static final _sharedHelper = locator<SharedHelper>();

  static bool getIsDarkModeTheme() {
    return _sharedHelper.getBool(
      ConstPreferences.darkModeKey,
      defaultValue: false,
    );
  }

  static Future<void> setIsDarkModeTheme({required bool isDarkMode}) async {
    await _sharedHelper.setBool(
      ConstPreferences.darkModeKey,
      value: isDarkMode,
    );
  }

  static int getAndroidSdkVersionInt() {
    return _sharedHelper.getInt(
      ConstPreferences.androidSdkVersionKey,
      defaultValue: 0,
    );
  }

  static Future<void> setAndroidSdkVersion({
    required int androidSdkVersion,
  }) async {
    await _sharedHelper.setInt(
      ConstPreferences.androidSdkVersionKey,
      value: androidSdkVersion,
    );
  }

  static int getLocalRevision() {
    return _sharedHelper.getInt(
      ConstPreferences.revisionLocalKey,
      defaultValue: 0,
    );
  }

  static Future<void> setLocalRevision({required int revision}) async {
    await _sharedHelper.setInt(
      ConstPreferences.revisionLocalKey,
      value: revision,
    );
  }

  static int getRemoteRevision() {
    return _sharedHelper.getInt(
      ConstPreferences.revisionRemoteKey,
      defaultValue: 0,
    );
  }

  static Future<void> setRemoteRevision({required int revision}) async {
    await _sharedHelper.setInt(
      ConstPreferences.revisionRemoteKey,
      value: revision,
    );
  }
}

class SharedHelper {
  SharedHelper(this._prefs);

  final SharedPreferences _prefs;

  Future<void> setInt(String key, {required int value}) async {
    await _prefs.setInt(key, value);
  }

  int getInt(String key, {required int defaultValue}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  Future<void> setBool(String key, {required bool value}) async {
    await _prefs.setBool(key, value);
  }

  bool getBool(String key, {required bool defaultValue}) {
    return _prefs.getBool(key) ?? defaultValue;
  }
}
