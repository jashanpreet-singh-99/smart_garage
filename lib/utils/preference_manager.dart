import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static setString(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  static getString(String key, String def) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? def;
  }
}
