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
}

class SharedHelper {
  SharedHelper(this._prefs);

  final SharedPreferences _prefs;

  Future<void> setBool(String key, {required bool value}) async {
    await _prefs.setBool(key, value);
  }

  bool getBool(String key, {required bool defaultValue}) {
    return _prefs.getBool(key) ?? defaultValue;
  }
}
