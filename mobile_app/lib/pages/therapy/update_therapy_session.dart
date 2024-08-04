// lib/pages/therapy/update_therapy_session.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/therapy_session.dart';
import '../../services/therapy_api.dart';

class UpdateTherapySession extends StatefulWidget {
  final TherapySession session;

  const UpdateTherapySession({Key? key, required this.session}) : super(key: key);

  @override
  _UpdateTherapySessionState createState() => _UpdateTherapySessionState();
}

class _UpdateTherapySessionState extends State<UpdateTherapySession> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TextEditingController _durationController;
  late TextEditingController _agendaController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.session.scheduledAt;
    _selectedTime = TimeOfDay.fromDateTime(widget.session.scheduledAt);
    _durationController = TextEditingController(text: widget.session.duration.toString());
    _agendaController = TextEditingController(text: widget.session.sessionAgenda);
  }

  @override
  void dispose() {
    _durationController.dispose();
    _agendaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Therapy Session'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text('Time: ${_selectedTime.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _agendaController,
              decoration: InputDecoration(labelText: 'Session Agenda'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final updatedSession = await TherapyAPI.rescheduleSession(
                sessionId: widget.session.sessionId,
                scheduledAt: _selectedDate,
                duration: int.parse(_durationController.text),
                sessionAgenda: _agendaController.text,
              );
              Navigator.of(context).pop(updatedSession);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update session: $e')),
              );
            }
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}