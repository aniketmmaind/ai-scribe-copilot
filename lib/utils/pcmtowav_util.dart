import 'dart:convert';
import 'dart:typed_data';

class PcmtowavUtil {
  static Uint8List pcmToWav(
    Uint8List pcmBytes, {
    int sampleRate = 16000,
    int channels = 1,
    int bitsPerSample = 16,
  }) {
    int byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
    int blockAlign = channels * (bitsPerSample ~/ 8);
    int wavSize = 44 + pcmBytes.length;

    final header = BytesBuilder();

    // RIFF header
    header.add(ascii.encode('RIFF'));
    header.add(_intToBytes(wavSize - 8, 4));
    header.add(ascii.encode('WAVE'));

    // fmt chunk
    header.add(ascii.encode('fmt '));
    header.add(_intToBytes(16, 4)); // PCM header size
    header.add(_intToBytes(1, 2)); // Audio format = 1 (PCM)
    header.add(_intToBytes(channels, 2));
    header.add(_intToBytes(sampleRate, 4));
    header.add(_intToBytes(byteRate, 4));
    header.add(_intToBytes(blockAlign, 2));
    header.add(_intToBytes(bitsPerSample, 2));

    // data chunk
    header.add(ascii.encode('data'));
    header.add(_intToBytes(pcmBytes.length, 4));

    // Append PCM data
    header.add(pcmBytes);

    return Uint8List.fromList(header.toBytes());
  }

  static Uint8List _intToBytes(int value, int byteCount) {
    final bytes = Uint8List(byteCount);
    final bd = ByteData.view(bytes.buffer);
    if (byteCount == 4) {
      bd.setUint32(0, value, Endian.little);
    } else if (byteCount == 2) {
      bd.setUint16(0, value, Endian.little);
    }
    return bytes;
  }
}
