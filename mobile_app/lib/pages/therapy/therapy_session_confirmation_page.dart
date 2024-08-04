// lib/pages/therapy/therapy_session_confirmation_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/therapy_session.dart';
import 'package:url_launcher/url_launcher.dart';

class TherapySessionConfirmationPage extends StatelessWidget {
  final TherapySession session;

  const TherapySessionConfirmationPage({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation'),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your therapy session has been booked!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(session.scheduledAt)}'),
            Text('Time: ${DateFormat('HH:mm').format(session.scheduledAt)}'),
            Text('Duration: ${session.duration} minutes'),
            Text('Agenda: ${session.sessionAgenda}'),
            Text('Therapist: ${session.therapistName}'),
            SizedBox(height: 16),
            if (session.zoomMeetingUrl != null)
              ElevatedButton(
                onPressed: () => _launchURL(session.zoomMeetingUrl!),
                child: Text('Join Zoom Meeting'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFb2c2a1),
                  foregroundColor: Colors.white,
                ),
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFb2c2a1),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}