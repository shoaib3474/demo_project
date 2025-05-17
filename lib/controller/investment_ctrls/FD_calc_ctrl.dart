import 'dart:math';

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class FDController {
  static const String _key = 'fd_calculator_result';

  /// Calculate Fixed Deposit maturity amount
  /// amount = principal investment
  /// rate = annual interest rate (in %)
  /// time = duration in years
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final r = rate / 100;
    final n = 1; // Compounded yearly (you can adjust for monthly/quarterly)
    final maturityAmount = amount * pow((1 + r / n), n * time);
    final interestEarned = maturityAmount - amount;

    return BaseCalculatorModel(
      amount: amount,
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
