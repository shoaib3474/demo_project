import 'package:demo_project/utils/services/base_shared_preference.dart';
import '../models/base_calculator_model.dart';

class DepreciationController {
  static const String _key = 'depreciation_result';

  /// Calculates:
  /// - Annual Depreciation
  /// - Total Depreciation
  /// - Percentage per year
  static BaseCalculatorModel calculate({
    required double purchasePrice,
    required double scrapValue,
    required double usefulLife,
  }) {
    final double totalDepreciation = purchasePrice - scrapValue;
    final double annualDepreciation = totalDepreciation / usefulLife;
    final double percentPerYear = (annualDepreciation / purchasePrice) * 100;

    return BaseCalculatorModel(
      amount: purchasePrice,
      rate: scrapValue,
      time: usefulLife,
      timeType: 'Yearly',
      result1: annualDepreciation, // Depreciation per year
      result2: totalDepreciation, // Total Depreciation
      result3:
          percentPerYear, // % Depreciation per year (add this to your model)
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
