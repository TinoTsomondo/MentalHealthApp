// lib/services/journal_api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/journal_entry.dart';

class JournalApi {
  static const String baseUrl = 'http://10.0.2.2:3001/api';

  static Future<List<JournalEntry>> fetchJournalEntries(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/journal/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => JournalEntry.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch journal entries: ${response.body}');
    }
  }

  static Future<void> submitJournalEntry(JournalEntry entry) async {
    final response = await http.post(
      Uri.parse('$baseUrl/journal'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entry.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit journal entry: ${response.body}');
    }
  }
}