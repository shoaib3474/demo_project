import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:demo_project/utils/constants/app_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/gen/assets.gen.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ExportResultUI extends StatelessWidget {
  final String title;
  final Map<String, String> inputData;
  final Map<String, String> resultData;
  final Map<String, double>? chartData;

  const ExportResultUI({
    super.key,
    required this.title,
    required this.inputData,
    required this.resultData,
    this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎯 Background Logo Watermark (diagonal)
          Positioned.fill(
            child: Center(
              child: Transform.rotate(
                angle: -0.8, // ~ -40 degrees for a nice diagonal
                child: Opacity(
                  opacity: 0.06,
                  child: SvgPicture.asset(
                    Assets.icons.itaxLogo,
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🌟 Main Foreground Content
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppTextStyles.heading20),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text("Inputs ", style: AppTextStyles.bold18Line32),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTable(inputData),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Outputs ", style: AppTextStyles.bold18Line32),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTable(resultData),
                  if (chartData != null) ...[
                    const SizedBox(height: 30),
                    _buildChart(chartData!),
                    const SizedBox(height: 10),
                    _buildLegend(chartData!),
                  ],
                ],
              ),
            ),
          ),

          // 🔻 Footer Website Text
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'www.itaxeasy.com', // Replace with your actual domain
                style: AppTextStyles.body14Medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(Map<String, String> data) {
    return Table(
      border: TableBorder.all(color: AppColors.secondary),
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(2)},
      children:
          data.entries.map((entry) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(entry.key),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildChart(Map<String, double> chartData) {
    return SizedBox(
      height: 150,
      width: 150,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 40,
          sections:
              chartData.entries.map((entry) {
                final color =
                    entry.key.toLowerCase().contains("interest")
                        ? AppColors.primary
                        : AppColors.secondary;
                return PieChartSectionData(
                  value: entry.value,
                  color: color,
                  title: '',
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegend(Map<String, double> chartData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          chartData.entries.map((entry) {
            final color =
                entry.key.toLowerCase().contains("interest")
                    ? AppColors.primary
                    : AppColors.secondary;
            return Row(
              children: [
                Container(width: 12, height: 12, color: color),
                const SizedBox(width: 5),
                Text(entry.key, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 10),
              ],
            );
          }).toList(),
    );
  }
}
