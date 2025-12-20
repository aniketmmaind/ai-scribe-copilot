import 'package:permission_handler/permission_handler.dart';

class PermissionController {
  static Future<bool> ensureMicPermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) return true;

    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  static Future<bool> ensurePhonePermission() async {
    final status = await Permission.phone.status;

    if (status.isGranted) return true;

    final result = await Permission.phone.request();
    return result.isGranted;
  }
}
