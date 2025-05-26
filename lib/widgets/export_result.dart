import 'package:demo_project/utils/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Input Table
              _buildTable(inputData),

              const SizedBox(height: 20),

              // Output Table
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
    );
  }

  Widget _buildTable(Map<String, String> data) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
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
                    style: const TextStyle(color: Colors.blue),
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
                        ? Colors.blue.shade300
                        : Colors.grey.shade300;
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
