// ignore_for_file: file_names

import 'dart:math';

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class RDController {
  static const String _key = 'rd_calculator_result';

  /// Calculate Recurring Deposit maturity amount
  /// amount = monthly investment
  /// rate = annual interest rate (percent)
  /// time = years
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final months = (time * 12).round();
    final r = rate / 100;

    // Indian RD formula (approximate, matches most online calculators)
    final investedAmount = amount * months;
    final interestEarned = amount * months * (months + 1) / 2 * (r / 12);
    final maturityAmount = investedAmount + interestEarned;

    return BaseCalculatorModel(
      amount: investedAmount, // Invested Amount
      result1: maturityAmount, // Total Amount (Maturity)
      result2: interestEarned, // Returns (Total Interest)
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
