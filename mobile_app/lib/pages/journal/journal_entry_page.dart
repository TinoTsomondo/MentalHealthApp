// lib/pages/journal_entry_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/journal_entry.dart';
import '../../services/journal_api.dart';

class JournalEntryPage extends StatefulWidget {
  final int userId;

  const JournalEntryPage({Key? key, required this.userId}) : super(key: key);

  @override
  _JournalEntryPageState createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFFB2C2A1),
            colorScheme: ColorScheme.light(primary: Color(0xFFB2C2A1)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitEntry() async {
    if (_formKey.currentState!.validate()) {
      try {
        final entry = JournalEntry(
          userId: widget.userId,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
          title: _titleController.text,
          content: _contentController.text,
        );

        await JournalApi.submitJournalEntry(entry);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Journal entry submitted successfully'),
            backgroundColor: Color(0xFFB2C2A1),
          ),
        );
        Navigator.pop(context, true);
      } catch (e) {
        print('Error submitting journal entry: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit journal entry: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8ED),
      appBar: AppBar(
        title: Text('New Journal Entry', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFB2C2A1),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Date',
                                suffixIcon: Icon(Icons.calendar_today, color: Color(0xFFB2C2A1)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              controller: TextEditingController(
                                text: DateFormat('MMMM d, y').format(_selectedDate),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            labelText: 'Journal Entry',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          maxLines: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your journal entry';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitEntry,
                    child: Text('Save Entry', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDCC9F3),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}