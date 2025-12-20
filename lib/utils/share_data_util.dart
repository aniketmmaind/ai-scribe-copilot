import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'file_util.dart';

class ShareUtil {
  static Future<void> shareTranscriptAsTxt(
    BuildContext context,
    String transcript, {
    String? patientName,
  }) async {
    if (transcript.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Transcript is empty")));
      return;
    }

    final filePath = await FileUtil.createTxtFile(
      transcript: transcript,
      patientName: patientName,
    );
    SharePlus.instance.share(
      ShareParams(files: [XFile(filePath)], subject: "Medical Transcript"),
    );
    // Share using native sheet
    // await Share.shareXFiles(
    //   [XFile(filePath)],
    //   subject: "Medical Transcript",
    //   sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    // );
  }
}
