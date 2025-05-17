// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

import 'package:demo_project/controller/income_tax_ctrls/HRA_ctrlr.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HRAcalcView extends StatefulWidget {
  const HRAcalcView({super.key});

  @override
  _HRAcalcViewState createState() => _HRAcalcViewState();
}

class _HRAcalcViewState extends State<HRAcalcView> {
  final totalInvstCtrl = TextEditingController();
  final HRA_ReceivedCtrl = TextEditingController();
  final DearnessCtrl = TextEditingController();
  final totalRentCtrl = TextEditingController();

  String timeType = 'Yearly';

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await HRAController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (totalInvstCtrl.text.isEmpty ||
        HRA_ReceivedCtrl.text.isEmpty ||
        DearnessCtrl.text.isEmpty ||
        totalRentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final totalInvestment = double.tryParse(totalInvstCtrl.text) ?? 0;
    final hraReceived = double.tryParse(HRA_ReceivedCtrl.text) ?? 0;
    final dearnessAllowance = double.tryParse(DearnessCtrl.text) ?? 0;
    final totalRentPaid = double.tryParse(totalRentCtrl.text) ?? 0;

    // Perform HRA calculation
    final hraExempted = HRAController.calculate(
      timeType: timeType,
      amount: totalInvestment,
      hraReceived: hraReceived,
      da: dearnessAllowance,
      rentPaid: totalRentPaid,
    );

    await HRAController.save(hraExempted);
    context.read<BaseCalculatorProvider>().setModel(hraExempted);
  }

  void _onClear() async {
    totalInvstCtrl.clear();
    HRA_ReceivedCtrl.clear();
    DearnessCtrl.clear();
    totalRentCtrl.clear();
    await HRAController.clear();
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
        title: 'HRA Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Investment", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Amount',
                  controller: totalInvstCtrl,
                  rightText: "₹",
                ),
                SizedBox(height: 8),
                Text("HRA Received (P.A)", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Amount',
                  controller: HRA_ReceivedCtrl,
                  rightText: "₹",
                ),
                SizedBox(height: 8),
                Text("Dearness Allowance", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Amount',
                  controller: DearnessCtrl,
                  rightText: "₹",
                ),
                SizedBox(height: 8),
                Text("Total Rent Paid", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Amount',
                  controller: totalRentCtrl,
                  rightText: "₹",
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (model != null)
            ResultChart(
              dataEntries: [
                ChartData(
                  value: model.result1 ?? 0.0,
                  color: AppColors.primary,
                  label: 'HRA Exempted',
                ),
                ChartData(
                  value: model.result2 ?? 0.0,
                  color: AppColors.secondary,
                  label: 'HRA Taxable',
                ),
              ],
              summaryRows: [
                SummaryRowData(label: "HRA", value: model.rate),
                SummaryRowData(label: "Exemption", value: model.result1 ?? 0.0),
                SummaryRowData(
                  label: "50 % Basic",
                  value: model.result3 ?? 0.0,
                ),
                SummaryRowData(label: "Salary", value: model.result4 ?? 0.0),
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
