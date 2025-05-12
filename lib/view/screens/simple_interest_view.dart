import 'package:demo_project/providers/simple_interest_provider.dart';
import 'package:demo_project/utils/buttons/clear_calculate_button.dart';
import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:demo_project/utils/constants/app_text.dart';
import 'package:demo_project/utils/custom/custom_appbar.dart';
import 'package:demo_project/utils/custom/custom_dropdown.dart';
import 'package:demo_project/view/screens/textfield.dart';
import 'package:demo_project/widgets/result_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:demo_project/models/simple_interest_model.dart'; // make sure it's imported
// import 'package:demo_project/widgets/result_card.dart';

class SimpleInterestView extends StatefulWidget {
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
    Provider.of<SimpleInterestProvider>(context, listen: false).load();
  }

  // share and download function
  void _shareOrDownload(
    SimpleInterestModel model, {
    required bool isShare,
  }) async {
    final resultText = '''
Simple Interest Result:
Principal: ₹${model.principal}
Rate: ${model.rate}%
Time: ${model.time} (${model.timeType})
Interest: ₹${model.interest}
Total: ₹${model.total}
''';

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/simple_interest_result.txt');
    await file.writeAsString(resultText);

    if (isShare) {
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Simple Interest Result');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File downloaded to: ${file.path}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SimpleInterestProvider>(context);
    final model = provider.model;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'Simple Interest Calculator',
        onBack: () => Navigator.pop(context),
        onDownload:
            model != null
                ? () => _shareOrDownload(model, isShare: false)
                : null,
        onShare:
            model != null ? () => _shareOrDownload(model, isShare: true) : null,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(" Principal  Amount", style: AppTextStyles.body16),

                // principal  Amount field
                CustomTextField(
                  hintText: 'Amount',
                  controller: principalCtrl,
                  rightText: "₹",
                ),
                SizedBox(height: 2),
                Text(" Rate of Interest(P.A)", style: AppTextStyles.body16),

                // Rate of Interest  Amount field
                CustomTextField(
                  hintText: 'Interest Amount',
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
                        items: ["Yearly", "Monthly", "Quaterly"],
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
          ResultChart(interest: model!.interest, principal: model.principal),

          Spacer(),
        ],
      ),
      bottomSheet: ClearCalculateButtons(
        onClearPressed: () {
          provider.clear();
          principalCtrl.clear();
          rateCtrl.clear();
          timeCtrl.clear();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Fields cleared")));
        },

        onCalculatePressed: () {
          if (principalCtrl.text.isEmpty ||
              rateCtrl.text.isEmpty ||
              timeCtrl.text.isEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
            return;
          }

          provider.calculate(
            double.tryParse(principalCtrl.text) ?? 0,
            double.tryParse(rateCtrl.text) ?? 0,
            double.tryParse(timeCtrl.text) ?? 0,
            timeType,
          );
        },
      ),
    );
  }
}
