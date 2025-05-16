import 'package:demo_project/routes/calc_routs.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/gen/assets.gen.dart';
import 'package:demo_project/utils/custom/calculator_card.dart';
import 'package:get/get.dart';
import '../../utils/utils.dart';
import 'package:flutter_svg/svg.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  final List<Map<String, dynamic>> _tools = [
    {
      'icon': Assets.icons.itr,
      'title': 'Bank\nCalculator',
      'color': AppColors.primary,
      'calculators': [
        "Simple Interest Calculator",
        "Compound Interest Calculator",
      ],
    },
    {
      'icon': Assets.icons.incomeTax,
      'title': "Income Tax\nCalculators",
      'color': Colors.purple,
      'calculators': [
        "HRA Calculator",
        "Depreciation Calculator",
        "Advance Tax Calculator (Old-Regime)",
        "Tax Calculator",
        "Capital Gain Calculator",
      ],
    },
    {
      'icon': Assets.icons.salesOrder1,
      'title': "Investment\nCalculators",
      'color': Colors.lime,
      'calculators': [
        "Post Office MIS",
        "CAGR Calculator",
        "RD Calculator",
        "FD Calculator",
        "Lump Sum Calculator",
        "SIP Calculator",
      ],
    },
    {
      'icon': Assets.icons.gst1,
      'title': "Loan\nCalculators",
      'color': Colors.green,
      'calculators': [
        "Loan Calculator",
        "Business Loan Calculator",
        "Car Loan Calculator",
        "Loan Against Property",
        "Home Loan Calculator",
        "Personal Loan Calculator",
      ],
    },
    {
      'icon': Assets.icons.invoice,
      'title': "Insurance\nCalculator",
      'color': Colors.red,
      'calculators': ["NPS Calculator"],
    },
  ];

  void _showBottomSheet(
    BuildContext context,
    List<String> calculators,
    String title,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder:
          (ctx) => Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title.replaceAll('\n', ' '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading20,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                ...calculators.map(
                  (calc) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(calc),
                      trailing: SvgPicture.asset(Assets.icons.rightArrow),
                      onTap: () {
                        final viewBuilder = calculatorRouteMap[calc];
                        Get.back(); // 👈 Pop the bottom sheet first
                        if (viewBuilder != null) {
                          Get.to(() => viewBuilder()); // ✅ Navigate using GetX
                        } else {
                          Get.snackbar("Error", "No screen found for $calc");
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children:
            _tools.map((tool) {
              return CalculatorCard(
                icon: tool['icon'],
                iconColor: tool['color'],
                title: tool['title'],
                onTap:
                    () => _showBottomSheet(
                      context,
                      tool['calculators'],
                      tool['title'],
                    ),
              );
            }).toList(),
      ),
    );
  }
}
