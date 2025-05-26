import 'dart:math';
import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class BusinessLoanController {
  static const String _key = 'business_loan_result';

  /// Calculates EMI, interest, and total payable amount for a business loan.
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final months = time * 12;
    final monthlyRate = rate / (12 * 100);

    final emi =
        (amount * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    final totalAmount = emi * months;
    final interest = totalAmount - amount;

    return BaseCalculatorModel(
      amount: amount,
      rate: rate,
      time: time,
      result1: emi, // EMI
      result2: interest, // Interest Amount
      result3: totalAmount, // Total Payable Amount
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
