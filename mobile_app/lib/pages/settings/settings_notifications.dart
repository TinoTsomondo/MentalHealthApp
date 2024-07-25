import 'package:flutter/material.dart';

class SettingsNotificationsPage extends StatelessWidget {
  const SettingsNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings', style: headingStyle),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: true, // This should be connected to your state management
            onChanged: (bool value) {
              // Handle enable/disable notification logic
            },
          ),
          ListTile(
            title: const Text('Notification Tone'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle notification tone selection
            },
          ),
          ListTile(
            title: const Text('Notification Types'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle notification type selection
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
