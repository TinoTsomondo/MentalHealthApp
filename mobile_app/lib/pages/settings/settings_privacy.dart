import 'package:flutter/material.dart';

class SettingsPrivacyPage extends StatelessWidget {
  const SettingsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings', style: headingStyle),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Share Data with Third Parties'),
            value: false, // This should be connected to your state management
            onChanged: (bool value) {
              // Handle data sharing logic
            },
          ),
          SwitchListTile(
            title: const Text('Profile Visibility'),
            value: true, // This should be connected to your state management
            onChanged: (bool value) {
              // Handle profile visibility logic
            },
          ),
          SwitchListTile(
            title: const Text('Activity Tracking'),
            value: true, // This should be connected to your state management
            onChanged: (bool value) {
              // Handle activity tracking logic
            },
          ),
        ],
      ),
    );
  }
}

// Styles
const TextStyle headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.blue,
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
);
