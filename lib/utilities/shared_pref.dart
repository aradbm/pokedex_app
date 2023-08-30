import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  static Future init() async =>
      _sharedPrefs = await SharedPreferences.getInstance();

  static Future setString(String key, String value) async =>
      await _sharedPrefs!.setString(key, value);

  static String? getString(String key) => _sharedPrefs!.getString(key);

  static Future setBool(String key, bool value) async =>
      await _sharedPrefs!.setBool(key, value);

  static bool? getBool(String key) => _sharedPrefs!.getBool(key);

  static Future setInt(String key, int value) async =>
      await _sharedPrefs!.setInt(key, value);

  static int? getInt(String key) => _sharedPrefs!.getInt(key);

  static Future setDouble(String key, double value) async =>
      await _sharedPrefs!.setDouble(key, value);

  static double? getDouble(String key) => _sharedPrefs!.getDouble(key);

  static Future setStringList(String key, List<String> value) async =>
      await _sharedPrefs!.setStringList(key, value);

  static List<String>? getStringList(String key) =>
      _sharedPrefs!.getStringList(key);

  static Future<bool> remove(String key) async =>
      await _sharedPrefs!.remove(key);

  static Future<bool> clear() async => await _sharedPrefs!.clear();
}
