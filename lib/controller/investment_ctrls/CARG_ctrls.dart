import 'dart:math';

import 'package:demo_project/utils/services/base_shared_preference.dart';
import 'package:demo_project/models/base_calculator_model.dart';

class CARGController {
  static const String _key = 'carg_result';

  /// Calculates the Compound Annual Growth Rate (CAGR)
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final finalValue = rate;
    final initialValue = amount;

    final carg = pow((finalValue / initialValue), (1 / time)) - 1;
    final cargPercent = carg * 100;

    final gain = finalValue - initialValue;

    return BaseCalculatorModel(
      amount: amount,
      rate: rate,
      time: time,
      result1: gain, // Total Gain
      result2: rate, // Final Investment
      result3: cargPercent.toDouble(), // CAGR %
    );
  }

  static Future<void> save(BaseCalculatorModel model) async {
    await BaseSharedPreference.save(_key, model);
  }

  static Future<BaseCalculatorModel?> load() async {
    return await BaseSharedPreference.load(_key);
  }

  static Future<void> clear() async {
    await BaseSharedPreference.clear(_key);
  }
}
