// ignore_for_file: file_names

import 'dart:math';

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class SIPController {
  /// Shared‑preferences key
  static const String _key = 'sip_calculator_result';

  /// Calculate SIP future value (maturity), invested amount, and interest earned
  ///
  /// * [amount]  – monthly investment (P)
  /// * [rate]    – annual interest rate in %
  /// * [time]    – investment duration in years (t)
  ///
  /// Formula (monthly compounding):
  /// ```
  /// r  = annualRate / 12 / 100        // monthly rate
  /// n  = time * 12                    // total months
  /// FV = P × [((1 + r)^n – 1) / r] × (1 + r)
  /// invested = P × n
  /// interest = FV – invested
  /// ```
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
  }) {
    final double monthlyRate = rate / 12 / 100;
    final int months = (time * 12).round();

    // Future value of a series (SIP) with monthly compounding
    double maturity = 0;
    if (monthlyRate > 0) {
      maturity =
          amount *
          (pow(1 + monthlyRate, months) - 1) /
          monthlyRate *
          (1 + monthlyRate);
    } else {
      maturity = amount * months; // zero‑interest edge case
    }

    final double invested = amount * months;
    final double interest = maturity - invested;

    return BaseCalculatorModel(
      amount: invested, // total money put in
      rate: rate,
      time: time,
      result1: maturity, // final corpus / total amount
      result2: interest, // gain / interest earned
    );
  }

  /// Save result in shared preferences
  static Future<void> save(BaseCalculatorModel model) async {
    await BaseSharedPreference.save(_key, model);
  }

  /// Load previously saved result
  static Future<BaseCalculatorModel?> load() async {
    return await BaseSharedPreference.load(_key);
  }

  /// Clear stored result
  static Future<void> clear() async {
    await BaseSharedPreference.clear(_key);
  }
}
