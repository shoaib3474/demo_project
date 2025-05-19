import 'dart:math';

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class PersonalLoanCtrl {
  static const String _key = 'personal_loan_result';

  /// Calculate EMI, interest amount, and total payable for personal loan.
  /// Uses compound interest formula.
  /// [amount] = Principal amount
  /// [rate] = Annual interest rate in %
  /// [time] = Loan tenure (can be years or months depending on timeType)
  /// [timeType] = 'Yearly' or 'Monthly'
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
    required String timeType,
  }) {
    final P = amount;
    final r = rate / 100;

    double totalPeriods;
    if (timeType.toLowerCase() == 'monthly') {
      totalPeriods = time;
    } else {
      totalPeriods = time * 12;
    }

    final monthlyRate = r / 12;

    // Compound interest formula: A = P * (1 + r/n)^(nt)
    // Here, n = 12 (monthly compounding), t = years
    // But we have totalPeriods as months, so A = P * (1 + monthlyRate)^totalPeriods
    final totalAmount = P * pow(1 + monthlyRate, totalPeriods);

    final interest = totalAmount - P;

    // For personal loans, let's assume EMI = totalAmount / totalPeriods
    final emi = totalAmount / totalPeriods;

    return BaseCalculatorModel(
      amount: P,
      result1: emi, // EMI
      result2: interest, // Interest amount
      result3: totalAmount, // Total amount payable
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
