import 'package:flutter/material.dart';

class TherapyPage extends StatelessWidget {
  const TherapyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapy Sessions'),
        backgroundColor: Color(0xFFB2C2A1), // Example green color
      ),
      body: Center(
        child: Text(
          'Therapy Sessions Content Here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
