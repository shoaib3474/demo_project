import 'dart:math';

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class HomeLoanCtrl {
  static const String _key = 'home_loan_result';

  /// Calculate EMI, total interest, and total amount payable for home loan.
  /// [amount] = Principal loan amount
  /// [rate] = Annual interest rate in %
  /// [time] = Loan tenure in years
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
    required String timeType,
  }) {
    final P = amount;
    final annualRate = rate;
    final years = time;

    final monthlyRate = annualRate / 12 / 100;
    final totalMonths = years * 12;

    final emi =
        (P * monthlyRate * pow(1 + monthlyRate, totalMonths)) /
        (pow(1 + monthlyRate, totalMonths) - 1);

    final totalPayable = emi * totalMonths;
    final interest = totalPayable - P;

    return BaseCalculatorModel(
      amount: P,
      result1: emi, // EMI
      result2: interest, // Interest amount
      result3: totalPayable, // Total amount payable
      rate: annualRate,
      time: years,
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
