// ignore_for_file: use_build_context_synchronously

import 'package:demo_project/models/simple_interest_model.dart';
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
import 'package:demo_project/providers/simple_interest_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

// import 'package:demo_project/widgets/result_card.dart';

class SimpleInterestView extends StatefulWidget {
  const SimpleInterestView({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

    // Get external storage directory (e.g., Downloads)
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/simple_interest_result.pdf');

    // Create PDF document
    final pdf = pw.Document();

    // Add a page with the resultText in the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(resultText, style: pw.TextStyle(fontSize: 18)),
          );
        },
      ),
    );

    // Write the PDF file to the storage
    await file.writeAsBytes(await pdf.save());

    if (isShare) {
      // Share the file via Share Plus plugin
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Simple Interest Result');
    } else {
      // Show Snackbar confirmation when the file is downloaded
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("PDF saved to: ${file.path}")));
    }
  }

  // permission request for downloading
  void _requestPermissions() async {
    // Check and request permission for storage
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Proceed with saving the file
    } else {
      // Show an error or request permission again
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission is required to save files.'),
        ),
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
        onDownload: () {
          // Request storage permissions before proceeding with file download
          _requestPermissions();

          // If permission is granted, proceed with the download
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('Choose File Type'),
                actions: [
                  TextButton(
                    onPressed: () {
                      _shareOrDownload(
                        model!,
                        isShare: false,
                      ); // Download as PDF
                      Navigator.pop(context);
                    },
                    child: Text('Download as PDF'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implement Image download logic if needed
                      Navigator.pop(context);
                    },
                    child: Text('Download as Image'),
                  ),
                ],
              );
            },
          );
        },

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
          // Assuming you have a model with principal and interest values
          model != null
              ? ResultChart(
                dataEntries: [
                  ChartData(
                    value: model.principal,
                    color: AppColors.secondary, // Use your color constants
                    label: 'Principal Amount',
                  ),
                  ChartData(
                    value: model.interest,
                    color: AppColors.primary, // Use your color constants
                    label: 'Interest Amount',
                  ),
                ],
              )
              : SizedBox.shrink(),

          Spacer(),
        ],
      ),
      bottomSheet: ClearCalculateButtons(
        onClearPressed: () {
          // Clear the model if it's not null
          provider.clear();

          // Clear the controllers safely
          principalCtrl.clear();
          rateCtrl.clear();
          timeCtrl.clear();

          // Show a snack bar notification
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
