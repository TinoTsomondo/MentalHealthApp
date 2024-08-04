// lib/pages/therapy/book_therapy_session_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/therapy_session.dart';
import '../../services/therapy_api.dart';
import 'therapy_session_confirmation_page.dart';

class BookTherapySessionPage extends StatefulWidget {
  final int userId;

  const BookTherapySessionPage({Key? key, required this.userId}) : super(key: key);

  @override
  _BookTherapySessionPageState createState() => _BookTherapySessionPageState();
}

class _BookTherapySessionPageState extends State<BookTherapySessionPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Map<String, dynamic>>> _therapists;
  int? _selectedTherapistId;
  String? _selectedTherapistName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _agendaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _therapists = TherapyAPI.fetchTherapists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Therapy Session'),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _therapists,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No therapists available');
                } else {
                  return DropdownButtonFormField<int>(
                    value: _selectedTherapistId,
                    items: snapshot.data!.map((therapist) {
                      return DropdownMenuItem<int>(
                        value: therapist['TherapistID'],
                        child: Text(therapist['FullName']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTherapistId = value;
                        _selectedTherapistName = snapshot.data!
                            .firstWhere((therapist) => therapist['TherapistID'] == value)['FullName'];
                      });
                    },
                    decoration: InputDecoration(labelText: 'Select Therapist'),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a therapist';
                      }
                      return null;
                    },
                  );
                }
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Select Date'
                  : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(_selectedTime == null
                  ? 'Select Time'
                  : _selectedTime!.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null && picked != _selectedTime) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the duration';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _agendaController,
              decoration: InputDecoration(labelText: 'Session Agenda'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the session agenda';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Book Session'),
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

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedTherapistId != null &&
        _selectedTherapistName != null) {
      DateTime scheduledAt = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      try {
        // Book the therapy session
        TherapySession bookedSession = await TherapyAPI.bookTherapySession(
          userId: widget.userId,
          therapistId: _selectedTherapistId!,
          therapistName: _selectedTherapistName!,
          scheduledAt: scheduledAt,
          duration: int.parse(_durationController.text),
          sessionAgenda: _agendaController.text,
        );

        // Create Zoom meeting
        final zoomMeeting = await TherapyAPI.createZoomMeeting(widget.userId, bookedSession);

        // Update session with Zoom details
        bookedSession = await TherapyAPI.updateSessionWithZoomDetails(
          bookedSession.sessionId,
          zoomMeeting['id'].toString(),
          zoomMeeting['join_url'],
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TherapySessionConfirmationPage(session: bookedSession),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book session: $e')),
        );
      }
    }
  }
}