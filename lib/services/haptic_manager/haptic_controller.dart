import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';

class HapticFeedbackManager {
  static const MethodChannel _channel = MethodChannel('dnd_check');

  static Future<bool> _isDndOn() async {
    try {
      final bool enabled = await _channel.invokeMethod("isDndEnabled");
      return enabled;
    } catch (e) {
      debugPrint("DND check failed: $e");
      return false;
    }
  }

  static Future<void> trigger(HapticType type) async {
    final isDnd = await _isDndOn();

    if (isDnd) {
      debugPrint("DND ON → Haptic blocked");
      return;
    }

    debugPrint("HAPTIC TRIGGERED ($type) — DND OFF");

    switch (type) {
      case HapticType.light:
        await HapticFeedback.lightImpact();
        break;

      case HapticType.medium:
        await HapticFeedback.mediumImpact();
        break;

      case HapticType.heavy:
        await HapticFeedback.heavyImpact();
        break;

      case HapticType.success:
        await HapticFeedback.lightImpact();
        await Future.delayed(Duration(milliseconds: 40));
        await HapticFeedback.mediumImpact();
        break;

      case HapticType.warning:
        await HapticFeedback.mediumImpact();
        break;

      case HapticType.error:
        await HapticFeedback.heavyImpact();
        break;

      case HapticType.selectionChng:
        await HapticFeedback.selectionClick();
        break;

      case HapticType.vibrate:
        await HapticFeedback.vibrate();
        break;
    }
  }
}
