import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountService {
  final String apiUrl = kReleaseMode 
    ? 'http://your-cloud-backend-url.com/api'
    : 'http://localhost:3001/api';

  // Create an account
  Future<void> createAccount(
      String username,
      String password,
      String email,
      String fullName,
      String dateOfBirth,
      String gender,
      bool isAnonymous) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/createAccount'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'isAnonymous': isAnonymous,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create account: ${response.body}');
    }
  }

  // Delete account without token
  Future<void> deleteAccount(String userId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/auth/deleteAccount/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account: ${response.body}');
    }
  }
}
