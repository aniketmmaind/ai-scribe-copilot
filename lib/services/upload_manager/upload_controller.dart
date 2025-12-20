import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:ai_scribe_copilot/repositories/recording/recording_session_repo.dart';
import 'package:ai_scribe_copilot/services/session_manager/session_controller.dart';
import '../../models/pending_chunk.dart';
import '../storage/local_db.dart';
import '../../utils/pcmtowav_util.dart';

class UploadController {
  bool _draining = false;
  final _recordingRepo = RecordingSessionRepo();
  UploadController();

  /// Called immediately after saving chunk
  Future<void> tryUploadNow(PendingChunk chunk) async {
    final success = await _upload(chunk);

    if (success) {
      // Remove from DB because uploaded
      await LocalDb.instance.delete("pending_chunks", "id = ?", [chunk.id]);
    } else {
      log("Immediate upload failed, will retry later");
    }
  }

  /// Background queue processing
  Future<void> autoDrainQueue() async {
    if (_draining) return;
    _draining = true;
    while (true) {
      final rows = await LocalDb.instance.query("pending_chunks");
      if (rows.isEmpty) break;

      final chunk = PendingChunk.fromMap(rows.first);
      final ok = await _upload(chunk);
      if (ok) {
        await LocalDb.instance.delete("pending_chunks", "id = ?", [chunk.id]);
      } else {
        break;
      }
    }

    _draining = false;
  }

  /// The actual uploader
  Future<bool> _upload(PendingChunk chunk) async {
    try {
      final file = File(chunk.localFilePath);
      if (!file.existsSync()) return false;

      Uint8List pcmBytes = await file.readAsBytes();
      Uint8List wavBytes = PcmtowavUtil.pcmToWav(pcmBytes);

      // always get a fresh presigned URL
      final presigned = await _recordingRepo.getPresignedUrl(
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SessionController.authToken}',
        },
        {
          "sessionId": chunk.sessionId,
          "chunkNumber": chunk.chunkNumber.toString(),
          "mimeType": chunk.mimeType,
        },
      );

      final url = presigned.url;
      final response = await _recordingRepo.setRecording(url!, {
        'Content-Type': chunk.mimeType,
        'Authorization': 'Bearer ${SessionController.authToken}',
      }, wavBytes);

      if (response == false) {
        return false;
      }

      // Notify backend
      await _recordingRepo.notifyChunckRecording(
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SessionController.authToken}',
        },
        {
          "sessionId": chunk.sessionId,
          "chunkNumber": chunk.chunkNumber,
          "publicUrl": presigned.publicUrl,
          "gcsPath": presigned.gcsPath,
          "mimeType": chunk.mimeType,
          "isLast": chunk.isLast,
          "liveTranscript": chunk.liveTranscript,
          "totalChunksClient": 0,
        },
      );

      return true;
    } catch (e) {
      log("Uploader error: $e");
      return false;
    }
  }
}
