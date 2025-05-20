// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

//pendding
import 'package:demo_project/controller/income_tax_ctrls/HRA_ctrlr.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaxtCalcView extends StatefulWidget {
  const TaxtCalcView({super.key});

  @override
  _TaxtCalcViewState createState() => _TaxtCalcViewState();
}

class _TaxtCalcViewState extends State<TaxtCalcView> {
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
        title: 'Tax Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(" PAN NO.", style: AppTextStyles.body16),
                CustomTextField(
                  hintText: 'Amount',
                  controller: totalInvstCtrl,
                  rightText: "₹",
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 8),
                Text(" Tax Payer", style: AppTextStyles.body16),
                CustomDropdown(
                  initialValue: "Select",
                  items: [],
                  onChanged: (String value) {},
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
                  SummaryRowData(
                    label: "Exemption",
                    value: model.result1 ?? 0.0,
                  ),
                  SummaryRowData(
                    label: "50 % Basic",
                    value: model.result3 ?? 0.0,
                  ),
                  SummaryRowData(label: "Salary", value: model.result4 ?? 0.0),
                ],
              )
            else
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),

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
