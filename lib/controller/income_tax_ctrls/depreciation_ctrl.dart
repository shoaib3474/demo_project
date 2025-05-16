// depreciation_ctrl.dart

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class DepreciationController {
  static const String _key = 'depreciation_result';

  static BaseCalculatorModel calculate({
    required double purchasePrice,
    required double scrapValue,
    required double usefulLife,
  }) {
    final double depreciationPerYear = (purchasePrice - scrapValue) / usefulLife;
    final double depreciationPercent = (depreciationPerYear / purchasePrice) * 100;

    final List<List<double>> yearlyTable = [];
    double opening = purchasePrice;

    for (int i = 1; i <= usefulLife; i++) {
      final depreciation = depreciationPerYear;
      final closing = opening - depreciation;
      yearlyTable.add([i.toDouble(), opening, depreciation, closing]);
      opening = closing;
    }

    return BaseCalculatorModel(
      amount: purchasePrice,
      rate: depreciationPercent,
      time: usefulLife,
      timeType: 'Year(s)',
      result1: depreciationPerYear,
      result2: depreciationPercent,
      result3: scrapValue,
      table: yearlyTable,
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
