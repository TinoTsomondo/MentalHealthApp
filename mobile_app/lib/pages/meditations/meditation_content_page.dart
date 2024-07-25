import 'package:flutter/material.dart';

class MeditationContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation'),
      ),
      body: Center(
        child: Text(
          'Meditation content goes here.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
