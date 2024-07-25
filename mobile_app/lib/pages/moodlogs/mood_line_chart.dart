// lib/mood_logs/mood_line_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/mood_log.dart'; // Ensure the correct path is used

class MoodLineChart extends StatelessWidget {
  final List<MoodLog> moodLogs;

  MoodLineChart({required this.moodLogs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.parse(moodLogs[value.toInt()].date.toString());
                    final day = date.day.toString().padLeft(2, '0');
                    final month = date.month.toString().padLeft(2, '0');
                    return Text('$day/$month');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            minX: 0,
            maxX: (moodLogs.length - 1).toDouble(),
            minY: 1,
            maxY: 5,
            lineBarsData: [
              LineChartBarData(
                spots: _generateSpots(moodLogs),
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                dotData: FlDotData(
                  show: true,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots(List<MoodLog> moodLogs) {
    return moodLogs.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.moodRating.toDouble());
    }).toList();
  }
}
