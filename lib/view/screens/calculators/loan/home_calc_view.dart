// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/loan/home_calc_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCalcView extends StatefulWidget {
  const HomeCalcView({super.key});

  @override
  _HomeCalcViewState createState() => _HomeCalcViewState();
}

class _HomeCalcViewState extends State<HomeCalcView> {
  final loanCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await HomeLoanCtrl.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);

      // Populate text fields with saved values
      loanCtrl.text = model.amount.toStringAsFixed(2);
      rateCtrl.text = model.rate.toStringAsFixed(2);
      timeCtrl.text = model.time.toStringAsFixed(2);
    }
  }

  void _onCalculate() async {
    if (loanCtrl.text.isEmpty ||
        rateCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final principal = double.tryParse(loanCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = HomeLoanCtrl.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: 'Yearly', // fixed since controller uses years
    );

    await HomeLoanCtrl.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    loanCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await HomeLoanCtrl.clear();
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
        title: 'Home Loan Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Loan Amount", style: AppTextStyles.body16),
              CustomTextField(
                hintText: 'Amount',
                controller: loanCtrl,
                rightText: "₹",
              ),
              const SizedBox(height: 8),
              Text("Rate of Interest (P.A)", style: AppTextStyles.body16),
              CustomTextField(
                hintText: 'Interest Rate',
                controller: rateCtrl,
                rightText: "%",
              ),
              const SizedBox(height: 8),
              Text("Loan Tenure (Years)", style: AppTextStyles.body16),
              CustomTextField(
                hintText: 'Years',
                controller: timeCtrl,
                rightText: "Y",
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    model == null
                        ? const SizedBox.shrink()
                        : ResultChart(
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
                              label: "Loan Amount",
                              value: model.amount,
                            ),
                            SummaryRowData(
                              label: "EMI",
                              value: model.result1 ?? 0.0,
                            ),
                            SummaryRowData(
                              label: "Interest Amount",
                              value: model.result2 ?? 0.0,
                            ),
                            SummaryRowData(
                              label: "Total Amount Payable",
                              value: model.result3 ?? 0.0,
                            ),
                          ],
                        ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _onClear,
                    child: const Text('Clear'),
                  ),
                  ElevatedButton(
                    onPressed: _onCalculate,
                    child: const Text('Calculate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
