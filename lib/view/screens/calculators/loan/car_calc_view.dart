// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/loan/car_calc_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarCalcView extends StatefulWidget {
  const CarCalcView({super.key});

  @override
  _CarCalcViewState createState() => _CarCalcViewState();
}

class _CarCalcViewState extends State<CarCalcView> {
  final loanCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  String timeType = 'Yearly';

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await CarLoanController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (loanCtrl.text.isEmpty ||
        rateCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final principal = double.tryParse(loanCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = CarLoanController.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: timeType,
    );

    await CarLoanController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    loanCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await CarLoanController.clear();
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
        title: 'Car Loan Calculator',
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
                  Text(" Loan Amount", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: 'Amount',
                    controller: loanCtrl,
                    rightText: "₹",
                  ),
                  SizedBox(height: 2),
                  Text(" Rate of Interest (P.A)", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: 'Interest Rate',
                    controller: rateCtrl,
                    rightText: "%",
                  ),
                  SizedBox(height: 2),
                  Text(" Loan Tenure", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: 'Years',
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
                    label: 'Loan Amount',
                  ),
                  ChartData(
                    value: model.result2 ?? 0.0,
                    color: AppColors.primary,
                    label: 'Interest Amount',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(label: "Loan Amount", value: model.amount),
                  SummaryRowData(label: "EMI", value: model.result1 ?? 0.0),
                  SummaryRowData(
                    label: "Interest Amount",
                    value: model.result2 ?? 0.0,
                  ),
                  SummaryRowData(
                    label: "Total Amount Payable",
                    value: model.result3 ?? 0.0,
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
