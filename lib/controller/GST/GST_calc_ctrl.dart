// ignore_for_file: file_names

import 'package:demo_project/models/base_calculator_model.dart';
import 'package:demo_project/utils/services/base_shared_preference.dart';

class GSTController {
  static const String _key = 'gst_calculator_result';

  /// Calculate GST breakdown
  /// [amount] is the original price
  /// [rate] is the GST percentage
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
  }) {
    final gstAmount = (amount * rate) / 100;
    final totalAmount = amount + gstAmount;

    return BaseCalculatorModel(
      amount: amount,
      result1: gstAmount,
      result2: totalAmount,
      rate: rate,
      time: 00,
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
