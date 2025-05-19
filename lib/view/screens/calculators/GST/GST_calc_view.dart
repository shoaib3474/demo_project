// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/GST/GST_calc_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GSTcalcView extends StatefulWidget {
  const GSTcalcView({super.key});

  @override
  _GSTcalcViewState createState() => _GSTcalcViewState();
}

class _GSTcalcViewState extends State<GSTcalcView> {
  final amountCtrl = TextEditingController();
  String selectedGST = "Select GST Type";
  String gstRate = "Select GST Rate";

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await GSTController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (amountCtrl.text.isEmpty ||
        gstRate == "Select GST Rate" ||
        selectedGST == "Select GST Type") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final amount = double.tryParse(amountCtrl.text) ?? 0;
    final rate = double.tryParse(gstRate.replaceAll("%", "")) ?? 0;

    final result = GSTController.calculate(amount: amount, rate: rate);

    await GSTController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    amountCtrl.clear();
    setState(() {
      gstRate = "Select GST Rate";
      selectedGST = "Select GST Type";
    });

    await GSTController.clear();
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
        title: 'GST Calculator',
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
                Text("Amount (₹)", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Enter amount',
                  controller: amountCtrl,
                  rightText: "₹",
                ),
                const SizedBox(height: 12),
                Text("GST Type", style: AppTextStyles.body16),
                CustomDropdown(
                  height: 52,
                  items: ["Regular", "Composition"],
                  initialValue: selectedGST,
                  onChanged: (val) {
                    setState(() => selectedGST = val);
                  },
                ),
                const SizedBox(height: 12),
                Text("GST Rate (%)", style: AppTextStyles.body16),
                CustomDropdown(
                  height: 52,
                  items: ["0%", "5%", "8%", "12%", "18%", "28%"],
                  initialValue: gstRate,
                  onChanged: (val) {
                    setState(() => gstRate = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (model != null)
              ResultChart(
                dataEntries: [
                  ChartData(
                    value: model.amount,
                    color: AppColors.secondary,
                    label: 'Actual Amount',
                  ),
                  ChartData(
                    value: model.result1 ?? 0.0,
                    color: AppColors.primary,
                    label: 'GST Amount',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(label: "Actual Amount", value: model.amount),
                  SummaryRowData(
                    label: "GST Amount",
                    value: model.result1 ?? 0.0,
                  ),
                  SummaryRowData(
                    label: "Post GST Amount",
                    value: model.result2 ?? 0.0,
                  ),
                ],
              )
            else
              const SizedBox.shrink(),
            const Spacer(),
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
