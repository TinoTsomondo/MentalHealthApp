// lib/pages/therapy/therapy_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/therapy_session.dart';
import '../../services/therapy_api.dart';
import 'update_therapy_session.dart';

class TherapyPage extends StatefulWidget {
  final TherapySession session;

  const TherapyPage({Key? key, required this.session}) : super(key: key);

  @override
  _TherapyPageState createState() => _TherapyPageState();
}

class _TherapyPageState extends State<TherapyPage> {
  late TherapySession _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  Future<void> _rescheduleSession() async {
    final updatedSession = await showDialog<TherapySession>(
      context: context,
      builder: (context) => UpdateTherapySession(session: _session),
    );

    if (updatedSession != null) {
      setState(() {
        _session = updatedSession;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session rescheduled successfully')),
      );
    }
  }

  Future<void> _cancelSession() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Session'),
        content: Text('Are you sure you want to cancel this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await TherapyAPI.cancelSession(_session.sessionId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session cancelled successfully')),
        );
        Navigator.of(context).pop(); // Return to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel session: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Details'),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Therapist: ${_session.therapistName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(_session.scheduledAt)}'),
            Text('Duration: ${_session.duration} minutes'),
            Text('Agenda: ${_session.sessionAgenda}'),
            Text('Therapist Email: ${_session.therapistEmail}'),
            SizedBox(height: 16),
            if (_session.zoomMeetingUrl != null)
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunch(_session.zoomMeetingUrl!)) {
                    await launch(_session.zoomMeetingUrl!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch Zoom meeting')),
                    );
                  }
                },
                child: Text('Join Meeting'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFb2c2a1)),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _rescheduleSession,
                  child: Text('Reschedule', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFfff9b0), // Yellow color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton(
                  onPressed: _cancelSession,
                  child: Text('Cancel Session', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFdcc9f3), // Lilac color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}