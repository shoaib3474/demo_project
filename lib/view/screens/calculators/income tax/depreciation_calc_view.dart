// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

import 'package:demo_project/controller/depreciation_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';

import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepreciationCalcView extends StatefulWidget {
  const DepreciationCalcView({super.key});

  @override
  _DepreciationCalcViewState createState() => _DepreciationCalcViewState();
}

class _DepreciationCalcViewState extends State<DepreciationCalcView> {
  final PPriceCtrl = TextEditingController();
  final scrapValueCtrl = TextEditingController();
  final usefulLifeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await DepreciationController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (PPriceCtrl.text.isEmpty ||
        scrapValueCtrl.text.isEmpty ||
        usefulLifeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final principal = double.tryParse(PPriceCtrl.text) ?? 0;
    final scrapValue =
        double.tryParse(scrapValueCtrl.text) ?? 0; // Fixed variable name
    final usefulLife =
        double.tryParse(usefulLifeCtrl.text) ?? 0; // Added useful life parsing

    // Perform depreciation calculation
    final result = DepreciationController.calculate(
      purchasePrice: principal,
      scrapValue: scrapValue,
      usefulLife: usefulLife,
    );

    await DepreciationController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    PPriceCtrl.clear();
    scrapValueCtrl.clear();
    usefulLifeCtrl.clear();

    await DepreciationController.clear();
    context.read<BaseCalculatorProvider>().clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Fields cleared")));
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BaseCalculatorProvider>().model;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'Depreciation Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(" Purchase Price", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Amount',
                  controller: PPriceCtrl,
                  rightText: "₹",
                ),
                SizedBox(height: 8),
                Text(" Scrap Value", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Value',
                  controller: scrapValueCtrl,
                  rightText: "%",
                ),
                SizedBox(height: 8),
                Text(" Estimated Useful Life", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Years',
                  controller: usefulLifeCtrl,
                  rightText: "Y",
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (model != null)
            ResultChart(
              dataEntries: [
                ChartData(
                  value: model.amount ?? 0.0,
                  color: AppColors.secondary,
                  label: 'Depreciation Amount',
                ),
                ChartData(
                  value: model.result1 ?? 0.0,
                  color: AppColors.primary,
                  label: 'Remaining Value',
                ),
              ],
            )
          else
            SizedBox.shrink(),
          Spacer(),
        ],
      ),
      bottomSheet: ClearCalculateButtons(
        onClearPressed: _onClear,
        onCalculatePressed: _onCalculate,
      ),
    );
  }
}
