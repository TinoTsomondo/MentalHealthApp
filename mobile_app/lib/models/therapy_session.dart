// lib/models/therapy_session.dart

class TherapySession {
  final int sessionId;
  final int userId;
  final int therapistId;
  final String therapistName;
  final String therapistEmail;
  final DateTime scheduledAt;
  final int duration;
  final String sessionAgenda;
  final String? zoomMeetingId;
  final String? zoomMeetingUrl;

  TherapySession({
    required this.sessionId,
    required this.userId,
    required this.therapistId,
    required this.therapistName,
    required this.therapistEmail,
    required this.scheduledAt,
    required this.duration,
    required this.sessionAgenda,
    this.zoomMeetingId,
    this.zoomMeetingUrl,
  });

  factory TherapySession.fromJson(Map<String, dynamic> json) {
    return TherapySession(
      sessionId: json['SessionID'],
      userId: json['UserID'],
      therapistId: json['TherapistID'],
      therapistName: json['TherapistName'],
      therapistEmail: json['TherapistEmail'],
      scheduledAt: DateTime.parse(json['ScheduledAt']),
      duration: json['Duration'],
      sessionAgenda: json['SessionAgenda'],
      zoomMeetingId: json['ZoomMeetingId'],
      zoomMeetingUrl: json['ZoomMeetingUrl'],
    );
  }
}