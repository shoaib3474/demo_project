import 'package:demo_project/utils/services/base_shared_preference.dart';
import 'package:demo_project/models/base_calculator_model.dart';

class PostOfficeMISController {
  static const String _key = 'post_office_mis_result';

  /// Calculates:
  /// - Monthly Interest = (P × R × T) / 100 ÷ (T × 12)
  /// - Total Interest = (P × R × T) / 100
  /// - Total Amount Payable = P + Total Interest
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final totalInterest = (amount * rate * time) / 100;
    final monthlyInterest = totalInterest / (time * 12);
    final totalPayable = amount + totalInterest;

    return BaseCalculatorModel(
      amount: amount, // P
      rate: rate, // R
      time: time, // T
      result1: monthlyInterest,
      result2: totalInterest,
      result3: totalPayable,
    );
  }

  /// Save the result to shared preferences
  static Future<void> save(BaseCalculatorModel model) async {
    await BaseSharedPreference.save(_key, model);
  }

  /// Load saved result from shared preferences
  static Future<BaseCalculatorModel?> load() async {
    return await BaseSharedPreference.load(_key);
  }

  /// Clear saved result
  static Future<void> clear() async {
    await BaseSharedPreference.clear(_key);
  }
}
