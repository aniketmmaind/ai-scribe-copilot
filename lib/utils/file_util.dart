import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class FileUtil {
  /// Creates a .txt file from transcript and returns file path
  static Future<String> createTxtFile({
    required String transcript,
    String? patientName,
  }) async {
    final dir = await getTemporaryDirectory();

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final safePatient =
        (patientName ?? 'patient').replaceAll(RegExp(r'\s+'), '_');

    final fileName = 'Transcript_${safePatient}_$timestamp.txt';
    final file = File('${dir.path}/$fileName');

    final content = '''
Medical Transcript
------------------
Patient: ${patientName ?? 'N/A'}
Date: ${DateTime.now().toLocal()}

------------------
$transcript
''';

    await file.writeAsString(content, flush: true);
    return file.path;
  }
}
