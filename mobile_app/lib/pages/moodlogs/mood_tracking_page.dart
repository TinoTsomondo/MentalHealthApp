import 'package:flutter/material.dart';

class MoodTrackingPage extends StatefulWidget {
  const MoodTrackingPage({super.key});

  @override
  _MoodTrackingPageState createState() => _MoodTrackingPageState();
}

class _MoodTrackingPageState extends State<MoodTrackingPage> {
  int? _selectedMood;
  final _descriptionController = TextEditingController();
  List<String> _availableTags = [
    'Stress', 'Happy', 'Sad', 'Energetic', 'Tired',
    'Anxious', 'Relaxed', 'Excited', 'Bored', 'Motivated',
    'Angry', 'Calm'
  ];
  List<String> _selectedTags = [];
  List<Map<String, dynamic>> _moodLogs = [];

  void _submitMood() {
    if (_selectedMood != null) {
      setState(() {
        _moodLogs.add({
          'MoodRating': _selectedMood!,
          'MoodDescription': _descriptionController.text,
          'MoodTags': _selectedTags.join(', '),
          'LogDate': DateTime.now(),
        });

        _selectedMood = null;
        _descriptionController.clear();
        _selectedTags.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood logged successfully!'),
          duration: Duration(seconds: 5),
          backgroundColor: Color(0xFFb2c2a1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a mood before submitting.'),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildMoodButton(int mood, String emoji, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: _selectedMood == mood ? color.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: color,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(
              fontSize: 24,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mood Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFb2c2a1),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _availableTags.map((tag) {
            return ChoiceChip(
              label: Text(tag),
              selected: _selectedTags.contains(tag),
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              selectedColor: Color(0xFFdcc9f3),
              backgroundColor: Color(0xFFfff9b0),
              labelStyle: TextStyle(
                color: _selectedTags.contains(tag) ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracking'),
        backgroundColor: Color(0xFFb2c2a1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select Your Mood',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFb2c2a1),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildMoodButton(1, '😞', Colors.red),
                _buildMoodButton(2, '😕', Colors.orange),
                _buildMoodButton(3, '😐', Colors.yellow),
                _buildMoodButton(4, '😊', Colors.lightGreen),
                _buildMoodButton(5, '😁', Color(0xFFb2c2a1)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Mood Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFb2c2a1),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter mood description...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFfff8ed),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            _buildTagSelector(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitMood,
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Color(0xFFb2c2a1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your Mood Logs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFb2c2a1),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _moodLogs.length,
              itemBuilder: (context, index) {
                final moodLog = _moodLogs[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text('Mood Rating: ${moodLog['MoodRating']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${moodLog['MoodDescription']}'),
                        Text('Tags: ${moodLog['MoodTags']}'),
                        Text('Logged At: ${moodLog['LogDate']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}