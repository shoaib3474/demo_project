import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../utils/utils.dart';

class ResultChart extends StatelessWidget {
  final List<ChartData> dataEntries;
  final List<SummaryRowData> summaryRows;

  const ResultChart({
    Key? key,
    required this.dataEntries,
    required this.summaryRows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show nothing if no data
    if (dataEntries.isEmpty || summaryRows.isEmpty)
      return const SizedBox.shrink();

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
              sections:
                  dataEntries
                      .map(
                        (entry) => PieChartSectionData(
                          value: entry.value,
                          color: entry.color,
                          showTitle: false,
                        ),
                      )
                      .toList(),
            ),
          ),
        ),

        // Legend
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children:
                dataEntries
                    .map(
                      (entry) =>
                          LegendItem(color: entry.color, text: entry.label),
                    )
                    .toList(),
          ),
        ),

        const SizedBox(height: 20),

        // Summary Box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children:
                  summaryRows.map((row) {
                    return Column(
                      children: [
                        SummaryRow(label: row.label, value: row.value),
                        const Divider(),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final double value;
  final Color color;
  final String label;

  ChartData({required this.value, required this.color, required this.label});
}

class SummaryRowData {
  final String label;
  final double value;

  SummaryRowData({required this.label, required this.value});
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;

  const SummaryRow({required this.label, required this.value, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body16)),
        Text(
          '₹ ${value.toStringAsFixed(0)}',
          style: AppTextStyles.heading20.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
