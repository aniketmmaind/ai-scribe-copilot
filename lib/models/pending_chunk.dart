import 'dart:convert';

class PendingChunk {
  String id;
  String sessionId;
  int chunkNumber;
  String localFilePath; // path to chunk wav file
  String gcsPath; // remote object path (from /get-presigned-url response)
  String publicUrl;
  String mimeType;
  bool isLast;
  int attempts;
  String status; // pending, uploading, done, failed
  String? liveTranscript;
  int createdAt;

  PendingChunk({
    required this.id,
    required this.sessionId,
    required this.chunkNumber,
    required this.localFilePath,
    required this.gcsPath,
    required this.publicUrl,
    required this.mimeType,
    required this.isLast,
    this.attempts = 0,
    this.status = 'pending',
    this.liveTranscript,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionId': sessionId,
      'chunkNumber': chunkNumber,
      'localFilePath': localFilePath,
      'gcsPath': gcsPath,
      'publicUrl': publicUrl,
      'mimeType': mimeType,
      'isLast': isLast ? 1 : 0,
      'attempts': attempts,
      'status': status,
      'liveTranscript': liveTranscript,
      'createdAt': createdAt,
    };
  }

  static PendingChunk fromMap(Map<String, dynamic> m) {
    return PendingChunk(
      id: m['id'],
      sessionId: m['sessionId'],
      chunkNumber: m['chunkNumber'],
      localFilePath: m['localFilePath'],
      gcsPath: m['gcsPath'],
      publicUrl: m['publicUrl'],
      mimeType: m['mimeType'],
      isLast: (m['isLast'] ?? 0) == 1,
      attempts: m['attempts'] ?? 0,
      status: m['status'] ?? 'pending',
      liveTranscript: m['liveTranscript'] ?? 'liveTranscript',
      createdAt: m['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());
}
