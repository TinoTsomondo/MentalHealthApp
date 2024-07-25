import 'package:flutter/material.dart';

class SettingsProfilePage extends StatelessWidget {
  const SettingsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings', style: headingStyle),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Change Username'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle change username logic
            },
          ),
          ListTile(
            title: const Text('Change Profile Picture'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle change profile picture logic
            },
          ),
          ListTile(
            title: const Text('Update Bio'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle update bio logic
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
