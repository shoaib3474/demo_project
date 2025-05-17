import 'dart:math';

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class RDController {
  static const String _key = 'rd_calculator_result';

  /// Calculate Recursive Deposit maturity amount
  /// amount = monthly investment
  /// rate = annual interest rate (percent)
  /// time = years
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final monthlyRate = rate / 12 / 100;
    final months = time * 12;

    double maturityAmount;
    if (monthlyRate > 0) {
      maturityAmount =
          amount * (pow(1 + monthlyRate, months) - 1) / monthlyRate;
    } else {
      maturityAmount = amount * months;
    }

    final investedAmount = amount * months;
    final interestEarned = maturityAmount - investedAmount;

    return BaseCalculatorModel(
      amount: investedAmount,
      result1: maturityAmount,
      result2: interestEarned,
      rate: rate,
      time: time,
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
