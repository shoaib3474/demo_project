import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultChart extends StatelessWidget {
  final List<ChartData> dataEntries;

  const ResultChart({Key? key, required this.dataEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = dataEntries.fold(0, (sum, entry) => sum + entry.value);

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

        SizedBox(height: 20),

        // Summary Box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ...dataEntries
                    .map(
                      (entry) => Column(
                        children: [
                          SummaryRow(label: entry.label, value: entry.value),
                          Divider(),
                        ],
                      ),
                    )
                    .toList(),
                SummaryRow(label: 'Total Amount', value: total),
              ],
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

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12)),
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
        Text(label, style: TextStyle(fontSize: 16)),
        Spacer(),
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
