// auth_service.dart
import 'package:flutter/foundation.dart'; // Import this for kReleaseMode
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  // Use local URL for debugging on emulator, cloud URL for production
  final String apiUrl = kReleaseMode 
    ? 'http://your-cloud-backend-url.com/api'
    : 'http://localhost:3001/api';

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> logout() async {
    // Implement your logout logic here
  }
}
