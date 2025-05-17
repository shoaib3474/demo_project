import 'package:demo_project/utils/services/base_shared_preference.dart';
import 'package:demo_project/models/base_calculator_model.dart';

class CapitalGainController {
  static const String _key = 'capital_gain_result';

  /// Calculates Capital Gain = Sale Price - Purchase Price
  static BaseCalculatorModel calculate({
    required double purchasePrice,
    required double salePrice,
  }) {
    final double capitalGain = salePrice - purchasePrice;

    return BaseCalculatorModel(
      amount: purchasePrice,
      rate: salePrice,
      result1: capitalGain,
      time: 32, // ✅ Capital Gain
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
