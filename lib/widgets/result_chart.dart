import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:demo_project/utils/constants/app_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ResultChart extends StatelessWidget {
  final double principal;
  final double interest;

  const ResultChart({Key? key, required this.principal, required this.interest})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = principal + interest;

    return Column(
      children: [
        // Pie Chart
        SizedBox(
          height: 150,
          child: PieChart(
            PieChartData(
              startDegreeOffset: 180,
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: principal,
                  color: AppColors.secondary,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: interest,
                  color: AppColors.primary,
                  showTitle: false,
                ),
              ],
            ),
          ),
        ),

        // Legend
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendItem(color: AppColors.secondary, text: 'Principal amount'),
              SizedBox(width: 20),
              LegendItem(color: AppColors.primary, text: 'Interest Amount'),
            ],
          ),
        ),

        SizedBox(height: 20),

        // Summary Box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SummaryRow(label: 'Principal Amount', value: principal),
                Divider(),
                SummaryRow(label: 'Total Earned', value: interest),
                Divider(),
                SummaryRow(label: 'Total Amount', value: total),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 4),
        Text(text, style: AppTextStyles.small14.copyWith(fontSize: 12)),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;

  const SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body16),
        Text(
          '₹ ${value.toStringAsFixed(0)}',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
