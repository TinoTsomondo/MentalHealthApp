import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  final String baseUrl = 'http://172.18.0.110:3001/api';

  Future<List<Map<String, String>>> fetchChats(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/chats/$userId'));
      print('API Response: ${response.body}');  // Log the API response

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<Map<String, String>>((item) => {
          'contactName': item['contactName']?.toString() ?? 'Unknown',
          'contactId': item['contactId']?.toString() ?? '',
          'lastMessage': item['Message']?.toString() ?? 'No message',
          'timestamp': item['Timestamp']?.toString() ?? '',
          'gender': item['Gender']?.toString() ?? 'unknown',
        }).toList();
      } else {
        throw Exception('Failed to load chats. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching chats: $e');
    }
  }

  Future<List<Map<String, String>>> fetchMessages(String userId, String contactId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/chats/messages/$userId/$contactId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<Map<String, String>>((item) => {
          'text': item['text']?.toString() ?? '',
          'sender': item['sender']?.toString() ?? '',
          'timestamp': item['Timestamp']?.toString() ?? DateTime.now().toIso8601String(),
        }).toList();
      } else {
        throw Exception('Failed to load messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }

  Future<List<Map<String, String>>> fetchNewMessages(String userId, String contactId, String? latestMessageTime) async {
    try {
      final url = latestMessageTime != null
          ? '$baseUrl/chats/messages/$userId/$contactId/new?timestamp=$latestMessageTime'
          : '$baseUrl/chats/messages/$userId/$contactId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<Map<String, String>>((item) => {
          'text': item['text']?.toString() ?? '',
          'sender': item['sender']?.toString() ?? '',
          'timestamp': item['Timestamp']?.toString() ?? DateTime.now().toIso8601String(),
        }).toList();
      } else {
        throw Exception('Failed to load new messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching new messages: $e');
    }
  }

  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'senderId': senderId,
          'receiverId': receiverId,
          'message': message,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}