// lib/mood_logs/mood_logs.dart

import 'package:flutter/material.dart';
import 'mood_tracking_page.dart';
import 'mood_line_chart.dart'; // Import the MoodLineChart
import '../../models/mood_log.dart'; // Import your MoodLog model

class MoodLogs extends StatelessWidget {
  MoodLogs({Key? key}) : super(key: key);  // Removed 'const' keyword

  // Sample mood logs data
  final List<MoodLog> moodLogs = [
    MoodLog(date: DateTime.now().subtract(Duration(days: 5)), moodRating: 3),
    MoodLog(date: DateTime.now().subtract(Duration(days: 4)), moodRating: 4),
    MoodLog(date: DateTime.now().subtract(Duration(days: 3)), moodRating: 2),
    MoodLog(date: DateTime.now().subtract(Duration(days: 2)), moodRating: 5),
    MoodLog(date: DateTime.now().subtract(Duration(days: 1)), moodRating: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
        backgroundColor: Color(0xFFb2c2a1), // Soft Green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome! Here you can track and reflect on your mood over time. '
              'Understanding your mood patterns can help you identify triggers '
              'and improve your emotional well-being.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Today\'s Mood',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('How are you feeling today?'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: 600,
                        width: double.maxFinite,
                        child: MoodTrackingPage(), // Embed MoodTrackingPage
                      ),
                    );
                  },
                );
              },
              child: Text('Log Mood'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Color(0xFFb2c2a1), // Soft Green
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your Mood Trends',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Here\'s a look at your mood over the past days.'),
            SizedBox(height: 10),
            MoodLineChart(moodLogs: moodLogs), // Replace placeholder with MoodLineChart
            SizedBox(height: 20),
            Text(
              'Notes and Reflections',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Add more UI elements as needed for notes and reflections
          ],
        ),
      ),
    );
  }
}
