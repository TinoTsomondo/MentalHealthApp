import 'package:flutter/material.dart';
import '../../services/account_service.dart';

class SettingsAccountManagementPage extends StatelessWidget {
  final AccountService accountService = AccountService();
  final int userId;

  SettingsAccountManagementPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Management'),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle change password logic
            },
          ),
          ListTile(
            title: const Text('Two-Factor Authentication'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle two-factor authentication logic
            },
          ),
          ListTile(
            title: const Text('Deactivate Account'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle account deactivation logic
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) async {
    try {
      await accountService.deleteAccount(userId.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }
}