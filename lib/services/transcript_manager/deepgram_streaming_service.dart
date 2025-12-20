import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/io.dart';

typedef TranscriptCallback = void Function(String text, bool isFinal);

class DeepgramStreamingService {
  final String apiKey;
  IOWebSocketChannel? _channel;

  TranscriptCallback? onTranscript;

  DeepgramStreamingService(this.apiKey);

  void connect() {
    final uri = Uri.parse(
      'wss://api.deepgram.com/v1/listen'
      '?encoding=linear16'
      '&sample_rate=16000'
      '&channels=1'
      '&punctuate=true'
      '&interim_results=true'
      '&model=nova-2-medical',
    );

    _channel = IOWebSocketChannel.connect(
      uri,
      headers: {'Authorization': 'Token $apiKey'},
    );

    _channel!.stream.listen(_handleMessage);
  }

  void sendPcm(Uint8List pcm) {
   _channel?.sink.add(pcm);
  }

  void _handleMessage(dynamic message) {
    final json = jsonDecode(message);
    final alternatives = json['channel']?['alternatives'];
    if (alternatives == null || alternatives.isEmpty) return;

    final transcript = alternatives[0]['transcript'];
    final isFinal = json['is_final'] == true;

    if (transcript != null && transcript.toString().isNotEmpty) {
      onTranscript?.call(transcript, isFinal);
    }
  }

  Future<void> close() async {
    await _channel?.sink.close();
    _channel = null;
  }
}
