// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/income_tax_ctrls/capital_gain_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:demo_project/utils/utils.dart';
import 'package:demo_project/view/screens/textfield.dart';

import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CapitalGainCalcView extends StatefulWidget {
  const CapitalGainCalcView({super.key});

  @override
  _CapitalGainCalcViewState createState() => _CapitalGainCalcViewState();
}

class _CapitalGainCalcViewState extends State<CapitalGainCalcView> {
  final purchaseCtrl = TextEditingController();
  final saleCtrl = TextEditingController();
  final capitalGainCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await CapitalGainController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
      purchaseCtrl.text = model.amount.toStringAsFixed(2);
      saleCtrl.text = model.rate.toStringAsFixed(2);
      capitalGainCtrl.text = model.result1?.toStringAsFixed(2) ?? '';
    }
  }

  void _onCalculate() async {
    final purchase = double.tryParse(purchaseCtrl.text);
    final sale = double.tryParse(saleCtrl.text);

    if (purchase == null || sale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter valid numeric values")),
      );

      return;
    }

    final model = CapitalGainController.calculate(
      purchasePrice: purchase,
      salePrice: sale,
    );

    capitalGainCtrl.text = model.result1?.toStringAsFixed(2) ?? '';

    context.read<BaseCalculatorProvider>().setModel(model);
    await CapitalGainController.save(model);
  }

  void _onClear() async {
    purchaseCtrl.clear();
    saleCtrl.clear();
    capitalGainCtrl.clear();
    await CapitalGainController.clear();
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
        title: 'Capital Gain Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Purchase Price", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Amount',
                  controller: purchaseCtrl,
                  rightText: "₹",
                ),
                const SizedBox(height: 12),
                Text("Sale Price", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Sale Rate',
                  controller: saleCtrl,
                  rightText: "₹",
                ),
                const SizedBox(height: 12),
                Text("Capital Gain", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Gain',
                  controller: capitalGainCtrl,
                  rightText: "₹",
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (model != null)
            ResultChart(
              dataEntries: [
                ChartData(
                  value: model.amount,
                  color: AppColors.secondary,
                  label: 'Purchase Price',
                ),
                ChartData(
                  value: model.result1 ?? 0.0,
                  color: AppColors.primary,
                  label: 'Capital Gain',
                ),
              ],
              summaryRows: [
                SummaryRowData(label: "Purchase Price", value: model.amount),
                SummaryRowData(
                  label: "Capital Gain",
                  value: model.result1 ?? 0.0,
                ),
                SummaryRowData(label: "Sale Price", value: model.rate),
              ],
            )
          else
            const SizedBox.shrink(),
          const Spacer(),
        ],
      ),
      bottomSheet: ClearCalculateButtons(
        onClearPressed: _onClear,
        onCalculatePressed: _onCalculate,
      ),
    );
  }
}
