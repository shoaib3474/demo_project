// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'package:demo_project/controller/insurance/NPS_calc_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/utils.dart';

class NPSCalcView extends StatefulWidget {
  const NPSCalcView({super.key});

  @override
  _NPSCalcViewState createState() => _NPSCalcViewState();
}

class _NPSCalcViewState extends State<NPSCalcView> {
  final investmentCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await NPSController.load();
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
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final amount = double.tryParse(investmentCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = NPSController.calculate(
      amount: amount,
      rate: rate,
      time: time,
    );

    await NPSController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    investmentCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();

    await NPSController.clear();
    context.read<BaseCalculatorProvider>().clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Fields cleared")));
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BaseCalculatorProvider>().model;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'NPS Calculator',
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
                  Text(" Monthly Investment", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: 'Amount',
                    controller: investmentCtrl,
                    rightText: "₹",
                  ),
                  const SizedBox(height: 8),
                  Text(
                    " Expected return rate (P.A)",
                    style: AppTextStyles.body16,
                  ),
                  CustomTextField(
                    hintText: 'Interest Rate',
                    controller: rateCtrl,
                    rightText: "%",
                  ),
                  const SizedBox(height: 8),
                  Text(" Your Age", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: "Years",
                    controller: timeCtrl,
                    rightText: "Y",
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
                    label: 'Invested Amount',
                  ),
                  ChartData(
                    value: model.result2 ?? 0.0,
                    color: AppColors.primary,
                    label: 'Total Interest',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(
                    label: "Total Investment",
                    value: model.amount,
                  ),
                  SummaryRowData(
                    label: "Interest Earned",
                    value: (model.result2 ?? 0),
                  ),
                  SummaryRowData(
                    label: "Maturity Amount",
                    value: (model.result1 ?? 0),
                  ),
                  SummaryRowData(
                    label: "Mini Annuity Investment",
                    value: (model.result3 ?? 0),
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
