import 'dart:developer';
import 'dart:io';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';

class LiveTranscriptionController {
  final Deepgram _dg;

  LiveTranscriptionController(String apiKey) : _dg = Deepgram(apiKey);

  Future<String?> transcribeWavChunk(String path) async {
    try {
      File file = File(path);
      if (!file.existsSync()) return null;

      final res = await _dg.listen.file(
        file,
        queryParams: {
          'model': 'nova-2-general',
          'punctuate': true,
          'filler_words': false,
          'detect_language': false,
          'language': 'en',
        },
      );
      return res.transcript;
    } catch (e) {
      log("Deepgram STT error: $e");
      return null;
    }
  }
}
