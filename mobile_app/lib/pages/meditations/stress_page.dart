import 'package:flutter/material.dart';

class StressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stress'),
      ),
      body: Center(
        child: Text(
          'Information and resources on managing stress.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
