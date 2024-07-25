// lib/services/moodlogs_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class MoodLogsService {
  final String baseUrl;

  /// Initializes the service with the given base URL.
  /// 
  /// Use `http://localhost:3001` for development (local environment).
  /// Use `http://your-deployed-server.com` for production.
  MoodLogsService(this.baseUrl);

  /// Fetches the mood logs for the specified user ID.
  ///
  /// Returns a list of mood logs as dynamic objects if the request is successful.
  /// Throws an exception if the request fails.
  Future<List<dynamic>> fetchMoodLogs(int userId) async {
    final url = '$baseUrl/api/moodlogs/$userId';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load mood logs');
      }
    } catch (error) {
      throw Exception('Failed to load mood logs: $error');
    }
  }

  /// Logs a new mood entry for the specified user ID with mood details.
  ///
  /// Requires the `userId`, `moodRating`, `moodDescription`, and `moodTags`.
  /// Throws an exception if logging fails.
  Future<void> logMood({
    required int userId,
    required int moodRating,
    required String moodDescription,
    required String moodTags,
  }) async {
    final url = '$baseUrl/api/moodlogs';
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'UserID': userId,
          'MoodRating': moodRating,
          'MoodDescription': moodDescription,
          'MoodTags': moodTags,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to log mood');
      }
    } catch (error) {
      throw Exception('Failed to log mood: $error');
    }
  }
}
