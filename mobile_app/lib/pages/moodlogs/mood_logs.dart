import 'package:flutter/material.dart';
import 'mood_tracking_page.dart';
import 'mood_line_chart.dart';
import '../../models/mood_log.dart';

class MoodLogs extends StatefulWidget {
  MoodLogs({Key? key}) : super(key: key);

  @override
  _MoodLogsState createState() => _MoodLogsState();
}

class _MoodLogsState extends State<MoodLogs> {
  final List<MoodLog> moodLogs = [
    MoodLog(date: DateTime.now().subtract(Duration(days: 5)), moodRating: 3),
    MoodLog(date: DateTime.now().subtract(Duration(days: 4)), moodRating: 4),
    MoodLog(date: DateTime.now().subtract(Duration(days: 3)), moodRating: 2),
    MoodLog(date: DateTime.now().subtract(Duration(days: 2)), moodRating: 5),
    MoodLog(date: DateTime.now().subtract(Duration(days: 1)), moodRating: 4),
  ];

  DateTime? _startDate;
  DateTime? _endDate;

  List<MoodLog> get filteredMoodLogs {
    return moodLogs.where((log) {
      return (_startDate == null || log.date.isAfter(_startDate!)) &&
          (_endDate == null || log.date.isBefore(_endDate!.add(Duration(days: 1))));
    }).toList();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _startDate ?? DateTime.now().subtract(Duration(days: 7)),
        end: _endDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFb2c2a1),
      ),
      body: Container(
        color: Color(0xFFFFF8ED),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Track Your Mood',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                'Log your daily moods and view trends over time to understand your emotional patterns. This can help you identify triggers, manage stress, and improve overall mental well-being.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                            height: 600,
                            width: double.maxFinite,
                            child: MoodTrackingPage(),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Log Today\'s Mood'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDCC9F3),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mood History',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDateRange(context),
                    child: Text('Filter Dates'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFF9B0),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
              if (_startDate != null && _endDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Showing mood logs from ${_startDate!.toLocal().toString().split(' ')[0]} to ${_endDate!.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
                  ),
                ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MoodLineChart(moodLogs: filteredMoodLogs),
                      SizedBox(height: 20),
                      Text(
                        'Understanding your mood patterns can provide valuable insights into your mental health. Regularly tracking your mood allows you to notice trends and triggers that affect your emotional state. This awareness can empower you to make informed decisions about your mental well-being and take proactive steps to improve it.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Remember, it’s okay to have ups and downs. What’s important is recognizing these patterns and seeking help if needed. Use this mood tracker as a tool to support your journey towards better mental health.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
