import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/mood_log.dart';

class MoodLineChart extends StatelessWidget {
  final List<MoodLog> moodLogs;

  MoodLineChart({required this.moodLogs});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200, // Adjust this value to make the chart shorter
          child: AspectRatio(
            aspectRatio:
                1.70, // Increased aspect ratio to make the chart wider relative to its height
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Color(0xFFB2C2A1).withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Color(0xFFB2C2A1).withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= moodLogs.length) return Text('');
                        final date = moodLogs[value.toInt()].date;
                        final day = date.day.toString().padLeft(2, '0');
                        final month = date.month.toString().padLeft(2, '0');
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '$day/$month',
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const emojis = ['😞', '😕', '😐', '😊', '😁'];
                        final index = value.toInt() - 1;
                        if (index >= 0 && index < emojis.length) {
                          return Text(emojis[index],
                              style: TextStyle(fontSize: 16));
                        }
                        return Text('');
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Color(0xFFB2C2A1)),
                ),
                minX: 0,
                maxX: (moodLogs.length - 1).toDouble(),
                minY: 1,
                maxY: 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateSpots(moodLogs),
                    isCurved: true,
                    color: Color(0xFFDCC9F3),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Color(0xFFDCC9F3),
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFFDCC9F3).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
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
