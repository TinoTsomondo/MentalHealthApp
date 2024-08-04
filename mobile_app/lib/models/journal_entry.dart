// lib/models/journal_entry.dart

class JournalEntry {
  final int? id;
  final int userId;
  final String date;
  final String title;
  final String content;

  JournalEntry({
    this.id,
    required this.userId,
    required this.date,
    required this.title,
    required this.content,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['JournalID'],
      userId: json['UserID'],
      date: json['Date'],
      title: json['Title'],
      content: json['EntryContent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'title': title,
      'content': content,
    };
  }
}