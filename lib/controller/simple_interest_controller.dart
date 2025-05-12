import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/simple_interest_model.dart';

class SimpleInterestController {
  final String _key = 'simple_interest_data';

  Future<void> save(SimpleInterestModel model) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(model.toJson()));
  }

  Future<SimpleInterestModel?> load() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(_key);
    if (jsonData != null) {
      return SimpleInterestModel.fromJson(jsonDecode(jsonData));
    }
    return null;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
