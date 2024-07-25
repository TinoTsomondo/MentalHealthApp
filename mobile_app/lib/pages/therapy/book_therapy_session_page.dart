import 'package:flutter/material.dart';
import '/api/therapy_api.dart'; // Import your API functions for booking sessions

class BookTherapySessionPage extends StatefulWidget {
  const BookTherapySessionPage({Key? key}) : super(key: key);

  @override
  _BookTherapySessionPageState createState() => _BookTherapySessionPageState();
}

class _BookTherapySessionPageState extends State<BookTherapySessionPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _therapistController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Therapy Session'),
        backgroundColor: const Color(0xFFB2C2A1), // Green color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Book a Therapy Session',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB2C2A1),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _therapistController,
                decoration: const InputDecoration(
                  labelText: 'Therapist Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the therapist name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Scheduled Date (YYYY-MM-DD HH:MM:SS)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the scheduled date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Book Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF9B0), // Yellow color
                  foregroundColor: Colors.black, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final therapistName = _therapistController.text;
      final scheduledDate = _dateController.text;
      final duration = int.parse(_durationController.text);

      try {
        await TherapyAPI.bookTherapySession(therapistName, scheduledDate, duration);
        Navigator.pop(context); // Go back to previous page after booking
      } catch (e) {
        // Handle error
        print('Error booking therapy session: $e');
      }
    }
  }
}
