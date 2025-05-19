// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/bank_ctrls/compound_interest_controller.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessCalcView extends StatefulWidget {
  const BusinessCalcView({super.key});

  @override
  _BusinessCalcViewState createState() => _BusinessCalcViewState();
}

class _BusinessCalcViewState extends State<BusinessCalcView> {
  final TextEditingController loanCtrl = TextEditingController();
  final TextEditingController rateCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();
  String timeType = 'Yearly';

  @override
  void initState() {
    super.initState();
    _loadPreviousResult();
  }

  Future<void> _loadPreviousResult() async {
    final model = await CompoundInterestCtrl.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  Future<void> _onCalculate() async {
    if (loanCtrl.text.isEmpty ||
        rateCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final principal = double.tryParse(loanCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = CompoundInterestCtrl.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: timeType,
    );

    await CompoundInterestCtrl.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  Future<void> _onClear() async {
    loanCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await CompoundInterestCtrl.clear();
    context.read<BaseCalculatorProvider>().clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fields cleared')));
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BaseCalculatorProvider>().model;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'Business Loan Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {}, // Add download logic
        onShare: () {}, // Add share logic
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(" Loan Amount", style: AppTextStyles.body16),
                  CustomTextField(
                    controller: loanCtrl,
                    hintText: 'Enter amount',
                    rightText: '₹',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),

                  Text(" Rate of Interest (P.A)", style: AppTextStyles.body16),
                  CustomTextField(
                    controller: rateCtrl,
                    hintText: 'Enter interest rate',
                    rightText: '%',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),

                  Text(" Time Period", style: AppTextStyles.body16),
                  CustomTextField(
                    controller: timeCtrl,
                    hintText: 'Enter time in years',
                    rightText: 'Y',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  if (model != null) ...[
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
                        SummaryRowData(
                          label: 'Loan Amount',
                          value: model.amount,
                        ),
                        SummaryRowData(
                          label: 'EMI',
                          value: model.result1 ?? 0.0,
                        ),
                        SummaryRowData(
                          label: 'Interest Amount',
                          value: model.result2 ?? 0.0,
                        ),
                        SummaryRowData(
                          label: 'Total Amount Payable',
                          value: model.result3 ?? 0.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
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
