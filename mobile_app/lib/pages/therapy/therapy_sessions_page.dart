// lib/pages/therapy/therapy_sessions_page.dart

import 'package:flutter/material.dart';
import '../../services/therapy_api.dart';
import '../../models/therapy_session.dart';
import 'package:intl/intl.dart';
import 'book_therapy_session_page.dart';
import 'therapy_page.dart';

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
    _loadTherapySessions();
  }

  void _loadTherapySessions() {
    _therapySessions = TherapyAPI.fetchTherapySessions(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Therapy Sessions'),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadTherapySessions();
          });
        },
        child: FutureBuilder<List<TherapySession>>(
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
                      subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(session.scheduledAt)),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TherapyPage(session: session),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookTherapySessionPage(userId: widget.userId)),
          );
          setState(() {
            _loadTherapySessions();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
    );
  }
}