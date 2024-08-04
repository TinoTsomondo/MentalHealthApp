// lib/services/therapy_api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/therapy_session.dart';

class TherapyAPI {
  static const String baseUrl = 'http://172.18.0.110:3001';

  static Future<List<TherapySession>> fetchTherapySessions(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/therapy-sessions?userId=$userId'));
    
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((session) => TherapySession.fromJson(session)).toList();
    } else {
      throw Exception('Failed to load therapy sessions');
    }
  }

  static Future<TherapySession> bookTherapySession({
    required int userId,
    required int therapistId,
    required String therapistName,
    required DateTime scheduledAt,
    required int duration,
    required String sessionAgenda,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/therapy-sessions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'UserID': userId,
        'TherapistID': therapistId,
        'TherapistName': therapistName,
        'ScheduledAt': scheduledAt.toUtc().toIso8601String(),
        'Duration': duration,
        'SessionAgenda': sessionAgenda,
      }),
    );

    if (response.statusCode == 201) {
      return TherapySession.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to book therapy session: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createZoomMeeting(int userId, TherapySession session) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/create-zoom-meeting'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'sessionId': session.sessionId,
        'topic': 'Therapy Session',
        'start_time': session.scheduledAt.toUtc().toIso8601String(),
        'duration': session.duration,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create Zoom meeting: ${response.body}');
    }
  }

  static Future<TherapySession> updateSessionWithZoomDetails(int sessionId, String zoomMeetingId, String zoomMeetingUrl) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/therapy-sessions/$sessionId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'ZoomMeetingId': zoomMeetingId,
        'ZoomMeetingUrl': zoomMeetingUrl,
      }),
    );

    if (response.statusCode == 200) {
      return TherapySession.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update session with Zoom details: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTherapists() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/therapists'));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        throw Exception('Failed to load therapists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load therapists: $e');
    }
  }

 static Future<TherapySession> rescheduleSession({
    required int sessionId,
    required DateTime scheduledAt,
    required int duration,
    required String sessionAgenda,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/therapy-sessions/reschedule/$sessionId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'ScheduledAt': scheduledAt.toUtc().toIso8601String(),
        'Duration': duration,
        'SessionAgenda': sessionAgenda,
      }),
    );

    if (response.statusCode == 200) {
      return TherapySession.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to reschedule therapy session: ${response.body}');
    }
  }

  static Future<void> cancelSession(int sessionId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/therapy-sessions/$sessionId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel therapy session: ${response.body}');
    }
  }
}

