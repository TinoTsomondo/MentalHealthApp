import 'package:flutter/material.dart';
import 'sleep_page.dart'; 
import 'stress_page.dart'; 
import 'anxiety_page.dart'; 

class MeditationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation'),
        backgroundColor: Color(0xFFb2c2a1), // Soft Green
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Find Your Calm',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFb2c2a1)),
            ),
            SizedBox(height: 10),
            Text(
              'Explore a variety of guided meditations to help you relax, reduce stress, and improve your well-being. Whether you are looking to improve your sleep, manage anxiety, or simply find a moment of peace, we have something for you.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              title: 'Sleep',
              color: Color(0xFFdcc9f3), // Light Purple
              page: SleepPage(),
              textColor: Colors.black,
            ),
            SizedBox(height: 10),
            _buildSection(
              context,
              title: 'Meditation Basics',
              color: Color(0xFFfff9b0), // Light Yellow
              page: MeditationPage(), // This should link to a specific meditation guide page
              textColor: Colors.black,
            ),
            SizedBox(height: 10),
            _buildSection(
              context,
              title: 'Anxiety Relief',
              color: Color(0xFFb2c2a1), // Soft Green
              page: AnxietyPage(),
              textColor: Colors.black,
            ),
            SizedBox(height: 10),
            _buildSection(
              context,
              title: 'Stress Management',
              color: Color(0xFFfff8ed), // Light Cream
              page: StressPage(),
              textColor: Colors.black,
            ),
            SizedBox(height: 20),
            Text(
              'Daily Mindfulness Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFb2c2a1)),
            ),
            SizedBox(height: 10),
            Text(
              '“Mindfulness is the art of being present and fully engaged with whatever we are doing at the moment, free from distraction or judgment, and aware of our thoughts and feelings without getting caught up in them.”',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement tracking or reminder feature
              },
              child: Text('Set Meditation Reminder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFb2c2a1), // Soft Green
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Color color, required Widget page, required Color textColor}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
