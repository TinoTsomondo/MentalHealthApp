import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/therapy_session.dart';

class TherapyAPI {
  static const String baseUrl = 'http://172.18.0.110:3001'; // Replace with your actual API base URL

  static Future<List<TherapySession>> fetchTherapySessions(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/therapy-sessions?userId=$userId'));
    
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((session) => TherapySession.fromJson(session)).toList();
    } else {
      throw Exception('Failed to load therapy sessions');
    }
  }
}