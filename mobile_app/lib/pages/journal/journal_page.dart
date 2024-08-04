// lib/pages/journal_page.dart

import 'package:flutter/material.dart';
import '../../models/journal_entry.dart';
import '../../services/journal_api.dart';
import 'journal_entry_page.dart';
import 'journal_details_page.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  final int userId;
  final String username;

  const JournalPage({Key? key, required this.userId, required this.username}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> journalEntries = [];
  List<JournalEntry> filteredEntries = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchJournalEntries();
  }

  Future<void> fetchJournalEntries() async {
    setState(() {
      isLoading = true;
    });
    try {
      final entries = await JournalApi.fetchJournalEntries(widget.userId);
      setState(() {
        journalEntries = entries;
        filteredEntries = entries;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch journal entries: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch journal entries')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterEntries(String query) {
    setState(() {
      filteredEntries = journalEntries
          .where((entry) =>
              entry.title.toLowerCase().contains(query.toLowerCase()) ||
              entry.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8ED),
      appBar: AppBar(
        title: Text(
          "${widget.username}'s Journal",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFB2C2A1),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search entries...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: filterEntries,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0xFFB2C2A1)))
                : filteredEntries.isEmpty
                    ? Center(
                        child: Text(
                          'No journal entries found',
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredEntries.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: Color(0xFFFFF9B0),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  filteredEntries[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('MMMM d, y').format(DateTime.parse(filteredEntries[index].date)),
                                  style: TextStyle(color: Colors.black54),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFB2C2A1)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JournalDetailsPage(entry: filteredEntries[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalEntryPage(userId: widget.userId),
            ),
          );
          if (result == true) {
            fetchJournalEntries();
          }
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFDCC9F3),
      ),
    );
  }
}