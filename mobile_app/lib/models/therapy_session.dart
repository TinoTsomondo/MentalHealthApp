class TherapySession {
  final int sessionId;
  final int userId;
  final int therapistId;
  final DateTime scheduledAt;
  final int duration;
  final String sessionAgenda;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String therapistName;
  final String therapistEmail;

  TherapySession({
    required this.sessionId,
    required this.userId,
    required this.therapistId,
    required this.scheduledAt,
    required this.duration,
    required this.sessionAgenda,
    required this.createdAt,
    required this.updatedAt,
    required this.therapistName,
    required this.therapistEmail,
  });

  factory TherapySession.fromJson(Map<String, dynamic> json) {
    return TherapySession(
      sessionId: json['SessionID'],
      userId: json['UserID'],
      therapistId: json['TherapistID'],
      scheduledAt: DateTime.parse(json['ScheduledAt']),
      duration: json['Duration'],
      sessionAgenda: json['SessionAgenda'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      therapistName: json['TherapistName'],
      therapistEmail: json['TherapistEmail'],
    );
  }
}