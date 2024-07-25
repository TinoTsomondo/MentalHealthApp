import 'package:flutter/material.dart';
import '../../services/therapy_api.dart';
import '../../models/therapy_session.dart';
import 'package:intl/intl.dart';

class TherapySessionsPage extends StatefulWidget {
  final int userId;

  const TherapySessionsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _TherapySessionsPageState createState() => _TherapySessionsPageState();
}

class _TherapySessionsPageState extends State<TherapySessionsPage> {
  late Future<List<TherapySession>> _therapySessions;

  @override
  void initState() {
    super.initState();
    _therapySessions = TherapyAPI.fetchTherapySessions(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Therapy Sessions'),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
      body: FutureBuilder<List<TherapySession>>(
        future: _therapySessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No therapy sessions found.'));
          } else {
            final sessions = snapshot.data!;
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text('Session with ${session.therapistName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(session.scheduledAt)}'),
                        Text('Duration: ${session.duration} minutes'),
                        Text('Agenda: ${session.sessionAgenda}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to session details page
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}