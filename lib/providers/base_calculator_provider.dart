import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/base_calculator_model.dart';

class BaseCalculatorProvider extends ChangeNotifier {
  BaseCalculatorModel? _model;

  BaseCalculatorModel? get model => _model;

  void setModel(BaseCalculatorModel model) {
    _model = model;
    notifyListeners();
  }

  void clear() {
    _model = null;
    notifyListeners();
  }

  Future<void> saveResult(String key) async {
    if (_model == null) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(_model!.toMap()));
  }

  Future<void> loadResult(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final data = jsonDecode(jsonString);
      _model = BaseCalculatorModel.fromMap(data);
      notifyListeners();
    }
  }
}
