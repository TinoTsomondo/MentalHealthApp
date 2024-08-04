import 'package:flutter/material.dart';
import 'chat_page.dart';
import '/services/chats_service.dart';

class ChatListPage extends StatefulWidget {
  final String userId;

  const ChatListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatService _chatService = ChatService();
  List<Map<String, String>> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    try {
      final contacts = await _chatService.fetchChats(widget.userId);
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching chats: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshChats() async {
    await _fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Color(0xFFFFF9B0), // Background color
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.black,
                    onPressed: () {
                      // Handle search action
                    },
                  ),
                ],
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshChats,
                      child: ListView.builder(
                        itemCount: _contacts.length,
                        itemBuilder: (context, index) {
                          final contact = _contacts[index];
                          final profilePicture = contact['gender'] == 'male' ? '👨' : '👩';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Card(
                              color: Color(0xFFB2C2A1), // Card background color
                              elevation: 5,
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    profilePicture,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                title: Text(
                                  contact['contactName'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  contact['lastMessage'] ?? 'No message',
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: Text(
                                  _formatTimestamp(contact['timestamp'] ?? ''),
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        contactName: contact['contactName'] ?? 'Unknown',
                                        contactId: contact['contactId'] ?? '',
                                        userId: widget.userId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';
    final dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }
}
