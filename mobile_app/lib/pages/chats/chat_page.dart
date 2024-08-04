import 'package:flutter/material.dart';
import '/services/chats_service.dart';
import 'package:intl/intl.dart';

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
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatService.joinRoom(widget.userId);
    _chatService.listenForNewMessages(_handleNewMessage);
    _fetchMessages();
  }

  void _handleNewMessage(Map<String, dynamic> newMessage) {
    setState(() {
      _messages.add(newMessage);
      _groupMessagesByDate();
    });
    _scrollToBottom();
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await _chatService.fetchMessages(widget.userId, widget.contactId);
      setState(() {
        _messages.addAll(messages);
        _groupMessagesByDate();
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _groupMessagesByDate() {
    _messages.sort((a, b) => DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp'])));

    String currentDate = '';
    for (var message in _messages) {
      final messageDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(message['timestamp']));
      if (messageDate != currentDate) {
        currentDate = messageDate;
        message['showDate'] = true;
      } else {
        message['showDate'] = false;
      }
    }
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _chatService.sendMessage(widget.userId, widget.contactId, _controller.text);
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUserMessage = message['sender'] == 'user';

                      return Column(
                        children: [
                          if (message['showDate'] == true)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                DateFormat('MMMM d, yyyy').format(DateTime.parse(message['timestamp'])),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Align(
                            alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isUserMessage ? Colors.black : Color(0xFFB2C2A1),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['text'] ?? '',
                                    style: TextStyle(
                                      color: isUserMessage ? Colors.white : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _formatTimestamp(message['timestamp'] ?? ''),
                                    style: TextStyle(
                                      color: isUserMessage ? Colors.white70 : Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                      hintStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.black,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';
    final dateTime = DateTime.parse(timestamp);
    final time = DateFormat.jm().format(dateTime);
    return time;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
