import 'dart:convert';
import 'package:demo_project/models/base_calculator_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseSharedPreference {
  /// Save model using a unique key
  static Future<void> save(String key, BaseCalculatorModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(model.toMap()));
  }

  /// Load model using a unique key
  static Future<BaseCalculatorModel?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(key);
    if (jsonData != null) {
      return BaseCalculatorModel.fromMap(jsonDecode(jsonData));
    }
    return null;
  }

  /// Clear model using a unique key
  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
