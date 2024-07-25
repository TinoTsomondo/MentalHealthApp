class TherapySession {
  final DateTime scheduledAt;
  final int duration;
  final String sessionNotes;

  TherapySession({
    required this.scheduledAt,
    required this.duration,
    required this.sessionNotes,
  });

  factory TherapySession.fromJson(Map<String, dynamic> json) {
    return TherapySession(
      scheduledAt: DateTime.parse(json['ScheduledAt']),
      duration: json['Duration'],
      sessionNotes: json['SessionNotes'],
    );
  }
}