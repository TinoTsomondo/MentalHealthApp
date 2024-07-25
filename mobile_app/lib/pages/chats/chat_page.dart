import 'package:flutter/material.dart';
import '/services/chats_service.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  final String contactName;
  final String contactId;
  final String userId;

  const ChatPage({
    Key? key,
    required this.contactName,
    required this.contactId,
    required this.userId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _isLoading = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    // Set up a timer to fetch new messages every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _fetchNewMessages());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await _chatService.fetchMessages(widget.userId, widget.contactId);
      setState(() {
        _messages.addAll(messages);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNewMessages() async {
  try {
    final latestMessageTime = _messages.isNotEmpty ? _messages.first['timestamp'] : null;
    final newMessages = await _chatService.fetchNewMessages(widget.userId, widget.contactId, latestMessageTime);
    if (newMessages.isNotEmpty) {
      setState(() {
        _messages.insertAll(0, newMessages);
      });
    }
  } catch (e) {
    print('Error fetching new messages: $e');
  }
}

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.insert(0, {'text': _controller.text, 'sender': 'user', 'timestamp': DateTime.now().toIso8601String()});
      });

      try {
        await _chatService.sendMessage(widget.userId, widget.contactId, _controller.text);
        _controller.clear();
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.contactName}'),
        backgroundColor: Color(0xFFB2C2A1),
      ),
      body: Column(
        children: <Widget>[
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUserMessage = message['sender'] == 'user';
                      return Align(
                        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isUserMessage ? Colors.black : Color(0xFFB2C2A1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            message['text'] ?? '',
                            style: TextStyle(
                              color: isUserMessage ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFFFF9B0),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}