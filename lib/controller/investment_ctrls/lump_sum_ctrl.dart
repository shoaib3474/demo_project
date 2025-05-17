import 'dart:math';

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class LumpSumController {
  static const String _key = 'lump_sum_calculator_result';

  /// Calculate Lump Sum returns
  /// amount = initial investment
  /// rate = annual interest rate (in %)
  /// time = investment duration in years
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final maturityAmount = amount * pow(1 + (rate / 100), time);
    final interestEarned = maturityAmount - amount;

    return BaseCalculatorModel(
      amount: amount,
      rate: rate,
      time: time,
      result1: maturityAmount,
      result2: interestEarned,
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
