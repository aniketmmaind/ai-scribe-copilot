class SessionModel {
  SessionModel({required this.sessions});

  final List<Session> sessions;

  SessionModel copyWith({List<Session>? sessions}) {
    return SessionModel(sessions: sessions ?? this.sessions);
  }

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessions:
          json["sessions"] == null
              ? []
              : List<Session>.from(
                json["sessions"]!.map((x) => Session.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() => {
    "sessions": sessions.map((x) => x.toJson()).toList(),
  };
}

class Session {
  Session({
    required this.id,
    required this.date,
    required this.sessionTitle,
    required this.sessionSummary,
    required this.startTime,
  });

  final String? id;
  final DateTime? date;
  final dynamic sessionTitle;
  final String? sessionSummary;
  final DateTime? startTime;

  Session copyWith({
    String? id,
    DateTime? date,
    dynamic sessionTitle,
    String? sessionSummary,
    DateTime? startTime,
  }) {
    return Session(
      id: id ?? this.id,
      date: date ?? this.date,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      sessionSummary: sessionSummary ?? this.sessionSummary,
      startTime: startTime ?? this.startTime,
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json["id"],
      date: DateTime.tryParse(json["date"] ?? ""),
      sessionTitle: json["session_title"],
      sessionSummary: json["session_summary"],
      startTime: DateTime.tryParse(json["start_time"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "date":
        "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "session_title": sessionTitle,
    "session_summary": sessionSummary,
    "start_time": startTime?.toIso8601String(),
  };
}
