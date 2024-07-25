// api/therapy_api.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/therapy_session.dart'; // Make sure this import is correct

class TherapyAPI {
  static const String baseUrl = 'https://your-api-url.com';

  static Future<List<TherapySession>> fetchTherapySessions() async {
    final response = await http.get(Uri.parse('$baseUrl/therapy-sessions'));
    if (response.statusCode == 200) {
      Iterable jsonList = json.decode(response.body);
      return jsonList.map((session) => TherapySession.fromJson(session)).toList();
    } else {
      throw Exception('Failed to load therapy sessions');
    }
  }

  static Future<void> bookTherapySession(String therapistName, String scheduledDate, int duration) async {
    final response = await http.post(
      Uri.parse('$baseUrl/book-therapy-session'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'therapistName': therapistName,
        'scheduledDate': scheduledDate,
        'duration': duration,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to book therapy session');
    }
  }
}
