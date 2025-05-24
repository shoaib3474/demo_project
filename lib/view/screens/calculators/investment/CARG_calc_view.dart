// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'package:demo_project/controller/investment_ctrls/CARG_ctrls.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart'; // for formatNumber
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CARGcalcView extends StatefulWidget {
  const CARGcalcView({super.key});

  @override
  _CARGcalcViewState createState() => _CARGcalcViewState();
}

class _CARGcalcViewState extends State<CARGcalcView> {
  final intialInvestmentCtrl = TextEditingController();
  final finalInvstCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await CARGController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (intialInvestmentCtrl.text.isEmpty ||
        finalInvstCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final amount = double.tryParse(intialInvestmentCtrl.text) ?? 0;
    final rate = double.tryParse(finalInvstCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = CARGController.calculate(
      amount: amount,
      rate: rate,
      time: time,
    );

    await CARGController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    intialInvestmentCtrl.clear();
    finalInvstCtrl.clear();
    timeCtrl.clear();

    await CARGController.clear();
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
        title: 'CARG Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(" Initial Investment", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: 'Amount',
                    controller: intialInvestmentCtrl,
                    rightText: "₹",
                  ),
                  SizedBox(height: 2),
                  Text(" Final Investment", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: 'Final Value',
                    controller: finalInvstCtrl,
                    rightText: "₹",
                  ),
                  SizedBox(height: 2),
                  Text(" Time Period", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: "Years",
                    controller: timeCtrl,
                    rightText: "Y",
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (model != null)
              ResultChart(
                dataEntries: [
                  ChartData(
                    value: model.amount,
                    color: AppColors.secondary,
                    label: 'Initial Investment',
                  ),
                  ChartData(
                    value: model.result2 ?? 0.0,
                    color: AppColors.primary,
                    label: 'Final Investment',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(
                    label: "CARG Gain",
                    value: model.result1 ?? 0.0,
                  ),
                  SummaryRowData(
                    label: "CARG  %",
                    percentage:
                        model.result3 != null
                            ? "₹${(model.result3! * 100 / 100).toStringAsFixed(2)}% (P.A)"
                            : "₹0.00% (P.A)",
                  ),
                ],
              )
            else
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
      bottomSheet: ClearCalculateButtons(
        onClearPressed: _onClear,
        onCalculatePressed: _onCalculate,
      ),
    );
  }
}
