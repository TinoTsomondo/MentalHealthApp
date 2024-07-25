import 'package:flutter/material.dart';
import 'settings_notifications.dart';
import 'settings_privacy.dart';
import 'settings_profile.dart';
import 'settings_account_management.dart';

class SettingsPage extends StatelessWidget {
  final int userId;

  const SettingsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: headingStyle),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsNotificationsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Privacy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPrivacyPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsProfilePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Account Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsAccountManagementPage(userId: userId)),
              );
            },
          ),
        ],
      ),
    );
  }
}

const TextStyle headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
);