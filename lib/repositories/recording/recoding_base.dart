import 'package:ai_scribe_copilot/models/recorder/presigned_model.dart';

abstract class RecodingBase {
  Future<String> createSession(Map<String, String> headers, data);
  Future<PresignedModel> getPresignedUrl(Map<String, String> headers, data);
  Future<bool> setRecording(String url, Map<String, String> headers, data);
  Future<bool> notifyChunckRecording(Map<String, String> headers, data);
}
