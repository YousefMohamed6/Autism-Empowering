import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static late SharedPreferences prefs;

  static Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    return prefs.getString(key);
  }

  static Future<void> saveInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    return prefs.getInt(key);
  }

  static Future<void> saveObject<T>(String key, T object) async {
    String jsonString = jsonEncode(object);
    await prefs.setString(key, jsonString);
  }

  static Future<T?> getObject<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return fromJson(jsonMap);
    }
    return null;
  }

  static Future<void> saveBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key, {bool defaultIfNull = true}) async {
    bool? value = prefs.getBool(key);
    return value ?? defaultIfNull;
  }
}
