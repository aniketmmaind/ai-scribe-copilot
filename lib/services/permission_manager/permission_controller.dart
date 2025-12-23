import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController {
  static Future<bool> ensureMicPermission() async {
    if (kIsWeb) {
      // Web has no phone permission → allow
      return true;
    }
    final status = await Permission.microphone.status;

    if (status.isGranted) return true;

    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  static Future<bool> ensurePhonePermission() async {
    if (kIsWeb|| Platform.isIOS) {
      // Web has no phone permission → allow
      return true;
    }
    final status = await Permission.phone.status;

    if (status.isGranted) return true;

    final result = await Permission.phone.request();
    return result.isGranted;
  }

  static Future<bool> ensureNotificationPermission() async {
    if (kIsWeb) {
      // Web has no phone permission → allow
      return true;
    }
    final status = await Permission.notification.status;

    if (status.isGranted) return true;

    final result = await Permission.notification.request();
    return result.isGranted;
  }
}
