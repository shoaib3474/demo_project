import 'package:demo_project/controller/simple_interest_controller.dart';
import 'package:flutter/material.dart';

import '../models/simple_interest_model.dart';

class SimpleInterestProvider extends ChangeNotifier {
  final _controller = SimpleInterestController();
  SimpleInterestModel? _model;

  SimpleInterestModel? get model => _model;

  void calculate(double p, double r, double t, String type) {
    _model = SimpleInterestModel(
      principal: p,
      rate: r,
      time: t,
      timeType: type,
    );
    _controller.save(_model!);
    notifyListeners();
  }

  Future<void> load() async {
    _model = await _controller.load();
    notifyListeners();
  }

  void clear() {
    _model = null;
    _controller.clear();
    notifyListeners();
  }
}
