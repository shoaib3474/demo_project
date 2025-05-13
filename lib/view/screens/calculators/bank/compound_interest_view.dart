// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:demo_project/controller/compound_interest_controller.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/buttons/clear_calculate_button.dart';
import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:demo_project/utils/constants/app_text.dart';
import 'package:demo_project/utils/custom/custom_appbar.dart';
import 'package:demo_project/utils/custom/custom_dropdown.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompoundInterestView extends StatefulWidget {
  const CompoundInterestView({super.key});

  @override
  _CompoundInterestViewState createState() => _CompoundInterestViewState();
}

class _CompoundInterestViewState extends State<CompoundInterestView> {
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
    final model = await CompoundInterestController.load();
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

    final result = CompoundInterestController.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: timeType,
    );

    await CompoundInterestController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    principalCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await CompoundInterestController.clear();
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
        title: 'Compound Interest Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
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
