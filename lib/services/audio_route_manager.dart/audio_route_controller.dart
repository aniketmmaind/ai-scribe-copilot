import 'dart:async';
import 'package:ai_scribe_copilot/services/haptic_manager/haptic_controller.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:flutter/services.dart';

class AudioRouteListener {
  //call method channel to check audio route i.e mic
  static const _channel = MethodChannel('audio_route');

  final StreamController<AudioRouteStatus> _controller =
      StreamController.broadcast();

  Stream<AudioRouteStatus> get stream => _controller.stream;

  Future<void> start() async {
     await _channel.invokeMethod('start');

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onRouteChanged') {
        final route = call.arguments as String;
        _controller.add(_map(route));
      }
    });
  }

  AudioRouteStatus _map(String route) {
    HapticFeedbackManager.trigger(HapticType.success);
    switch (route) {
      case 'wired':
        return AudioRouteStatus.wiredHeadset;
      case 'bluetooth':
        return AudioRouteStatus.bluetooth;
      default:
        return AudioRouteStatus.speaker;
    }
  }

  void dispose() {
    _controller.close();
  }
}
