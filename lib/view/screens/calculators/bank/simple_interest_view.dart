// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/bank_ctrls/simple_interest_controller.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';

import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SimpleInterestView extends StatefulWidget {
  const SimpleInterestView({super.key});

  @override
  _SimpleInterestViewState createState() => _SimpleInterestViewState();
}

class _SimpleInterestViewState extends State<SimpleInterestView> {
  final principalCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  String timeType = 'Yearly';

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await SimpleInterestCtrl.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (principalCtrl.text.isEmpty ||
        rateCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final principal = double.tryParse(principalCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = SimpleInterestCtrl.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: timeType,
    );

    await SimpleInterestCtrl.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    principalCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await SimpleInterestCtrl.clear();
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
        title: 'Simple Interest Calculator',
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
                  Text(" Principal Amount", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: 'Amount',
                    controller: principalCtrl,
                    rightText: "₹",
                  ),
                  SizedBox(height: 2),
                  Text(" Rate of Interest(P.A)", style: AppTextStyles.body16),
                  CustomTextField(
                    hintText: 'Interest Rate',
                    controller: rateCtrl,
                    rightText: "%",
                  ),
                  SizedBox(height: 2),
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
            ),
            SizedBox(height: 20),
            if (model != null)
              ResultChart(
                dataEntries: [
                  ChartData(
                    value: model.amount,
                    color: AppColors.secondary,
                    label: 'Principal Amount',
                  ),
                  ChartData(
                    value: model.result1 ?? 0.0,
                    color: AppColors.primary,
                    label: 'Interest Amount',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(
                    label: "Principle Amount",
                    value: double.tryParse(principalCtrl.text) ?? 0.0,
                  ),
                  SummaryRowData(
                    label: "Total Earned",
                    value: model.result1 ?? 0.0,
                  ),
                  SummaryRowData(
                    label: "Total Amount",
                    value: (model.amount + (model.result1 ?? 0.0)),
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
