// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/investment_ctrls/FD_calc_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart'; // For formatNumber
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FDcalcView extends StatefulWidget {
  const FDcalcView({super.key});

  @override
  _FDcalcViewState createState() => _FDcalcViewState();
}

class _FDcalcViewState extends State<FDcalcView> {
  final investmentCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  String timeType = 'Yearly';

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await FDController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (investmentCtrl.text.isEmpty ||
        rateCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final amount = double.tryParse(investmentCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = FDController.calculate(
      amount: amount,
      rate: rate,
      time: time,
    );

    await FDController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    investmentCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();

    await FDController.clear();
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
        title: 'Fixed Deposit Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Invested", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Amount',
                  controller: investmentCtrl,
                  rightText: "₹",
                ),
                SizedBox(height: 8),
                Text("Expected return (P.A)", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Interest Rate',
                  controller: rateCtrl,
                  rightText: "%",
                ),
                SizedBox(height: 8),
                Text(" Time Period", style: AppTextStyles.body16),
                Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: CustomTextField(
                        hintText: 'Time',
                        controller: timeCtrl,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 126,
                      height: 52,
                      child: CustomDropdown(
                        height: 44,
                        items: ["Yearly", "Monthly", "Quarterly"],
                        initialValue: 'Yearly',
                        onChanged: (val) {
                          setState(() => timeType = val);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            if (model != null)
              ResultChart(
                dataEntries: [
                  ChartData(
                    value: model.amount,
                    color: AppColors.secondary,
                    label: 'Invested Amount',
                  ),
                  ChartData(
                    value: model.result2 ?? 0.0,
                    color: AppColors.primary,
                    label: 'Interest Earned',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(
                    label: "Invested Amount",
                    value: (model.amount),
                  ),
                  SummaryRowData(
                    label: "Interest Earned",
                    value: (model.result2 ?? 0.0),
                  ),
                  SummaryRowData(
                    label: "Total Maturity Amount",
                    value: (model.result1 ?? 0.0),
                  ),
                ],
              )
            else
              SizedBox.shrink(),
            Spacer(),
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
