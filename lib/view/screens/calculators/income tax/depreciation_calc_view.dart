// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

import 'package:demo_project/controller/income_tax_ctrls/depreciation_ctrl.dart';
import 'package:demo_project/providers/base_calculator_provider.dart';
import 'package:demo_project/utils/utils.dart';

import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepreciationCalcView extends StatefulWidget {
  const DepreciationCalcView({super.key});

  @override
  _DepreciationCalcViewState createState() => _DepreciationCalcViewState();
}

class _DepreciationCalcViewState extends State<DepreciationCalcView> {
  final PPriceCtrl = TextEditingController();
  final scrapValueCtrl = TextEditingController();
  final usefulLifeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await DepreciationController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (PPriceCtrl.text.isEmpty ||
        scrapValueCtrl.text.isEmpty ||
        usefulLifeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final principal = double.tryParse(PPriceCtrl.text) ?? 0;
    final scrapValue =
        double.tryParse(scrapValueCtrl.text) ?? 0; // Fixed variable name
    final usefulLife =
        double.tryParse(usefulLifeCtrl.text) ?? 0; // Added useful life parsing

    // Perform depreciation calculation
    final result = DepreciationController.calculate(
      purchasePrice: principal,
      scrapValue: scrapValue,
      usefulLife: usefulLife,
    );

    await DepreciationController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    PPriceCtrl.clear();
    scrapValueCtrl.clear();
    usefulLifeCtrl.clear();

    await DepreciationController.clear();
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
        title: 'Depreciation Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Input Fields
            SizedBox(height: 8),
            Text(" Purchase Price", style: AppTextStyles.body16),
            CustomTextField(
              hintText: 'Amount',
              controller: PPriceCtrl,
              rightText: "₹",
            ),
            SizedBox(height: 8),
            Text(" Scrap Value", style: AppTextStyles.body16),
            CustomTextField(
              hintText: 'Value',
              controller: scrapValueCtrl,
              rightText: "%",
            ),
            SizedBox(height: 8),
            Text(" Estimated Useful Life", style: AppTextStyles.body16),
            CustomTextField(
              hintText: 'Years',
              controller: usefulLifeCtrl,
              rightText: "Y",
            ),
            SizedBox(height: 20),

            /// Output Section (Chart + Table)
            if (model != null)
              Column(
                children: [
                  ResultChart(
                    dataEntries: [
                      ChartData(
                        value: model.amount ?? 0.0,
                        color: AppColors.secondary,
                        label: 'Cost of Asset',
                      ),
                      ChartData(
                        value: model.result1 ?? 0.0,
                        color: AppColors.primary,
                        label: 'Depreciation (P.A)',
                      ),
                    ],
                    summaryRows: [
                      SummaryRowData(
                        label: "Depreciation (P.A)",
                        value: model.result1 ?? 0.0,
                      ),
                      SummaryRowData(
                        label: "Depreciation Percentage %",
                        value: model.result2 ?? 0.0,
                      ),
                      SummaryRowData(
                        label: "Cost of Assets",
                        value: model.amount ?? 0.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Calculation", style: AppTextStyles.heading20),
                    ],
                  ),
                  SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          _tableCell(
                            "Year",
                            style: AppTextStyles.body16.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          _tableCell(
                            "Opening Value",
                            style: AppTextStyles.body16.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          _tableCell(
                            "Depreciation",
                            style: AppTextStyles.body16.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          _tableCell(
                            "Closing Value",
                            style: AppTextStyles.body16.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      for (var row in model.table ?? [])
                        TableRow(
                          children: [
                            _tableCell(
                              row[0].toInt().toString(),
                              style: AppTextStyles.body16.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            _tableCell(
                              row[1].toStringAsFixed(2),
                              style: AppTextStyles.body16.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            _tableCell(
                              row[2].toStringAsFixed(2),
                              style: AppTextStyles.body16.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            _tableCell(
                              row[3].toStringAsFixed(2),
                              style: AppTextStyles.body16.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 100), // Leave space for bottom buttons
          ],
        ),
      ),
      bottomSheet: ClearCalculateButtons(
        onClearPressed: _onClear,
        onCalculatePressed: _onCalculate,
      ),
    );
  }

  Widget _tableCell(String text, {required TextStyle style}) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center, style: style),
    ),
  );
}
