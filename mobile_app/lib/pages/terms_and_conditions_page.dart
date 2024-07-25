// terms_and_conditions_page.dart
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Terms and Conditions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text(
                '''1. Acceptance of Terms
By accessing and using this app, you agree to comply with and be bound by the following terms and conditions.

2. Use of App
You agree to use the app only for lawful purposes and in accordance with these terms.

3. User Responsibilities
You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.

4. Limitation of Liability
The app is provided "as is" and we make no warranties regarding its availability, accuracy, or reliability.

5. Changes to Terms
We reserve the right to modify these terms at any time. Continued use of the app constitutes acceptance of any changes.

6. Governing Law
These terms are governed by the laws of [Your Country/State]. 

If you have any questions about these terms, please contact us at [Contact Information].''',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
