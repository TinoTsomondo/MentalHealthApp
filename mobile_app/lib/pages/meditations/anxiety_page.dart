import 'package:flutter/material.dart';

class AnxietyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anxiety'),
      ),
      body: Center(
        child: Text(
          'Information and resources on managing anxiety.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
