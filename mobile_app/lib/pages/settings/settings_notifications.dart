import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationSettings extends ChangeNotifier {
  bool _enableNotifications = true;
  String _notificationTone = 'Default';
  List<String> _enabledNotificationTypes = ['Messages', 'Reminders'];

  bool get enableNotifications => _enableNotifications;
  String get notificationTone => _notificationTone;
  List<String> get enabledNotificationTypes => _enabledNotificationTypes;

  void toggleNotifications(bool value) {
    _enableNotifications = value;
    notifyListeners();
  }

  void setNotificationTone(String tone) {
    _notificationTone = tone;
    notifyListeners();
  }

  void toggleNotificationType(String type) {
    if (_enabledNotificationTypes.contains(type)) {
      _enabledNotificationTypes.remove(type);
    } else {
      _enabledNotificationTypes.add(type);
    }
    notifyListeners();
  }
}

class SettingsNotificationsPage extends StatelessWidget {
  const SettingsNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings', style: headingStyle),
        backgroundColor: const Color(0xFFb2c2a1),
      ),
      body: Consumer<NotificationSettings>(
        builder: (context, settings, child) {
          return ListView(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Enable Notifications', style: bodyTextStyle),
                value: settings.enableNotifications,
                onChanged: (bool value) {
                  settings.toggleNotifications(value);
                },
              ),
              ListTile(
                title: const Text('Notification Tone', style: bodyTextStyle),
                subtitle: Text(settings.notificationTone),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showToneSelectionDialog(context);
                },
              ),
              ListTile(
                title: const Text('Notification Types', style: bodyTextStyle),
                subtitle: Text(settings.enabledNotificationTypes.join(', ')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showNotificationTypesDialog(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showToneSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Notification Tone'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Provider.of<NotificationSettings>(context, listen: false)
                    .setNotificationTone('Default');
                Navigator.pop(context);
              },
              child: const Text('Default'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Provider.of<NotificationSettings>(context, listen: false)
                    .setNotificationTone('Chime');
                Navigator.pop(context);
              },
              child: const Text('Chime'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Provider.of<NotificationSettings>(context, listen: false)
                    .setNotificationTone('Bell');
                Navigator.pop(context);
              },
              child: const Text('Bell'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationTypesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification Types'),
          content: Consumer<NotificationSettings>(
            builder: (context, settings, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text('Messages'),
                    value: settings.enabledNotificationTypes.contains('Messages'),
                    onChanged: (bool? value) {
                      settings.toggleNotificationType('Messages');
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Reminders'),
                    value: settings.enabledNotificationTypes.contains('Reminders'),
                    onChanged: (bool? value) {
                      settings.toggleNotificationType('Reminders');
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Updates'),
                    value: settings.enabledNotificationTypes.contains('Updates'),
                    onChanged: (bool? value) {
                      settings.toggleNotificationType('Updates');
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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