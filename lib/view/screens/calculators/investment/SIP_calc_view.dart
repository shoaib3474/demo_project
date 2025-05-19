// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/investment_ctrls/SIP_calc_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SIPcalcView extends StatefulWidget {
  const SIPcalcView({super.key});

  @override
  _SIPcalcViewState createState() => _SIPcalcViewState();
}

class _SIPcalcViewState extends State<SIPcalcView> {
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
    final model = await SIPController.load();
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

    final result = SIPController.calculate(
      amount: amount,
      rate: rate,
      time: time,
    );

    await SIPController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    investmentCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();

    await SIPController.clear();
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
        title: 'SIP Calculator',
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
                  Text("Monthly Investment", style: AppTextStyles.body16),
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
                  Text("Time Period", style: AppTextStyles.body16),
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
                    label: 'Total Invested',
                  ),
                  ChartData(
                    value: model.result2 ?? 0.0,
                    color: AppColors.primary,
                    label: 'Total Interest',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(label: "Invested Amount", value: model.amount),
                  SummaryRowData(
                    label: "Total Return",
                    value: (model.result2 ?? 0),
                  ),
                  SummaryRowData(
                    label: "Total Amount",
                    value: (model.result1 ?? 0),
                  ),
                ],
              )
            else
              SizedBox.shrink(),
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
