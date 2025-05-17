import 'dart:math';

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class NPSController {
  static const String _key = 'nps_calculator_result';

  /// Calculate NPS maturity values
  /// amount = monthly investment
  /// rate = annual interest rate (in %)
  /// time = age in years (or investment duration)
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final r = rate / 100;
    final n = 12; // monthly compounding for SIP/NPS
    final months = time * 12;

    // Future Value of a series formula: FV = P * [((1 + r/n)^(nt) - 1) / (r/n)]
    final maturityAmount = amount * ((pow((1 + r / n), months) - 1) / (r / n));
    final totalInvested = amount * months;
    final interestEarned = maturityAmount - totalInvested;

    // Mini Annuity Investment is a placeholder (can be customized)
    final miniAnnuityInvestment = totalInvested * 0.1; // example 10%

    return BaseCalculatorModel(
      amount: totalInvested,
      result1: maturityAmount,
      result2: interestEarned,
      result3: miniAnnuityInvestment,
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
