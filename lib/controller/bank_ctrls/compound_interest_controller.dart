import 'dart:math';
import 'package:demo_project/utils/services/base_shared_preference.dart';
import '../../models/base_calculator_model.dart';

class CompoundInterestCtrl {
  static const String _key = 'compound_interest_result';

  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
    required String timeType,
  }) {
    final int n = _getCompoundFrequency(timeType);
    final double r = rate / 100;

    final double compoundAmount = amount * (pow((1 + r / n), n * time));

    final double interest = compoundAmount - amount;

    return BaseCalculatorModel(
      amount: amount,
      rate: rate,
      time: time,
      timeType: timeType,
      result1: interest, // Interest only
      result2: compoundAmount, // Total amount
    );
  }

  static int _getCompoundFrequency(String timeType) {
    switch (timeType.toLowerCase()) {
      case 'monthly':
        return 12;
      case 'quarterly':
        return 4;
      case 'yearly':
      default:
        return 1;
    }
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
