import 'dart:developer';
import 'package:speech_to_text/speech_to_text.dart';

class OnDeviceSpeechController {
  final SpeechToText _speech = SpeechToText();
  bool _initialized = false;

  Future<bool> init() async {
    if (_initialized) return true;

    _initialized = await _speech.initialize(
      onStatus: (status) => log('Speech status: $status'),
      onError: (error) => log('Speech error: $error'),
    );
    return _initialized;
  }

  void start({required Function(String text, bool isFinal) onResult}) async {
    if (!_initialized) return;

    // if (!_speech.isOnDeviceSupported) {
    //   log('On-device speech not supported');
    //   return;
    // }

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenMode: ListenMode.dictation,
      partialResults: true, // live preview
      // listenOptions: SpeechListenOptions().partialResults,
      localeId: "en_US",
    );
  }

  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  Future<void> cancel() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
  }
}
