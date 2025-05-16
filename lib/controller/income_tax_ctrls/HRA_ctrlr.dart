// ignore_for_file: unused_local_variable

import 'package:demo_project/utils/services/base_shared_preference.dart';
import '../../models/base_calculator_model.dart';

class HRAController {
  static const String _key = 'hra_result';

  static BaseCalculatorModel calculate({
    required double amount, // ✅ Basic Salary
    required double hraReceived, // ✅ HRA Received
    required double da, // ✅ Dearness Allowance
    required double rentPaid, // ✅ Rent Paid
    required String timeType,
  }) {
    final double salaryWithDA = amount + da;
    final double rentMinus10Percent = rentPaid - (0.10 * salaryWithDA);
    final double fiftyPercentOfSalary = 0.50 * salaryWithDA;

    final double exemptedHRA = [
      hraReceived,
      rentMinus10Percent,
      fiftyPercentOfSalary,
    ].reduce((a, b) => a < b ? a : b).clamp(0, double.infinity);

    final double taxableHRA = hraReceived - exemptedHRA;

    return BaseCalculatorModel(
      amount: amount, // ✅ Basic Salary
      rate: hraReceived, // ✅ HRA Received
      time: rentPaid, // ✅ Rent Paid
      timeType: timeType,
      result1: exemptedHRA, // ✅ HRA Exempted
      result2: taxableHRA, // ✅ HRA Taxable
      result3: fiftyPercentOfSalary, // ✅ 50% Basic
      result4: salaryWithDA, // ✅ Salary (Basic + DA)
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
