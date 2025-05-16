import 'package:demo_project/utils/services/base_shared_preference.dart';
import '../../models/base_calculator_model.dart';

class DepreciationController {
  static const String _key = 'simple_interest_result';

  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
    required String timeType,
  }) {
    final double years = _convertToYears(time, timeType);
    final double interest = (amount * rate * years) / 100;
    final double total = amount + interest;

    return BaseCalculatorModel(
      amount: amount,
      rate: rate,
      time: time,
      timeType: timeType,
      result1: interest,
      result2: total,
    );
  }

  // Convert time to years based on selected timeType
  static double _convertToYears(double time, String timeType) {
    switch (timeType.toLowerCase()) {
      case 'monthly':
        return time / 12;
      case 'quarterly':
        return time / 4;
      case 'yearly':
      default:
        return time;
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
