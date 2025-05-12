import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefsService {
  static const String _calcHistoryKey = 'calc_history';

  // Save result (append to existing list)
  static Future<void> saveResult(Map<String, dynamic> result) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_calcHistoryKey) ?? [];
    history.add(jsonEncode(result));
    await prefs.setStringList(_calcHistoryKey, history);
  }

  // Get all results
  static Future<List<Map<String, dynamic>>> getResults() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_calcHistoryKey) ?? [];
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // Clear all history
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_calcHistoryKey);
  }
}
