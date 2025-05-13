import 'package:demo_project/utils/services/base_shared_preference.dart';
import '../models/base_calculator_model.dart';

class HRAController {
  static const String _key = 'hra_result';

  /// Calculate HRA Exemption and Taxable HRA
  static BaseCalculatorModel calculate({
    required double amount, // Basic Salary
    required double hraReceived,
    required double da,
    required double rentPaid,
    required String timeType,
  }) {
    final double basicPlusDA = amount + da;
    final double tenPercent = 0.10 * basicPlusDA;
    final double excessRent = rentPaid - tenPercent;
    final double metroRate = 0.50 * basicPlusDA;
    final double nonMetroRate = 0.40 * basicPlusDA;

    // Assuming non-metro by default. Replace with user input if needed.
    final double salaryLimit = nonMetroRate;

    final double exemptedHRA = [
      hraReceived,
      salaryLimit,
      excessRent,
    ].reduce((a, b) => a < b ? a : b).clamp(0, double.infinity);

    final double taxableHRA = hraReceived - exemptedHRA;

    return BaseCalculatorModel(
      amount: amount,
      rate: hraReceived,
      time: rentPaid,
      timeType: timeType,
      result1: exemptedHRA,
      result2: taxableHRA,
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
