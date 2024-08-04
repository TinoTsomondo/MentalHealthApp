import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class ChatService {
  final String baseUrl = 'http://172.18.0.110:3001';
  late IO.Socket socket;

  ChatService() {
    socket = IO.io(baseUrl, IO.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((_) {
      print('Connected to WebSocket server');
    });
  }

  void joinRoom(String userId) {
    socket.emit('join', userId);
  }

  void listenForNewMessages(Function(Map<String, String>) onNewMessage) {
    socket.on('newMessage', (data) {
      onNewMessage(Map<String, String>.from(data));
    });
  }

  Future<List<Map<String, String>>> fetchChats(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/chats/$userId'));
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
      final response = await http.get(Uri.parse('$baseUrl/api/chats/messages/$userId/$contactId'));

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
          ? '$baseUrl/api/chats/messages/$userId/$contactId/new?timestamp=$latestMessageTime'
          : '$baseUrl/api/chats/messages/$userId/$contactId';
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
    socket.emit('sendMessage', {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
    });
  }
}