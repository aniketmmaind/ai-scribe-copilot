import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Function(String actionId)? _onAction;

  static void setOnAction(Function(String) callback) {
    _onAction = callback;
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'recording_category',
          actions: [
            DarwinNotificationAction.plain('pause', 'Pause'),
            DarwinNotificationAction.plain('resume', 'Resume'),
            DarwinNotificationAction.plain('stop', 'Stop'),
          ],
        ),
      ],
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
      macOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log(
          "➡️ FOREGROUND ACTION: actionId=${response.actionId}, payload=${response.payload}",
        );

        if (_onAction != null) {
          if (response.actionId != null) {
            _onAction!(response.actionId!); // Action buttons
          } else if (response.payload != null) {
            _onAction!(response.payload!); // Notification body tap
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    await _createRecordingChannel();
  }

  static Future<void> showRecordingNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails
    androidDetails = AndroidNotificationDetails(
      'rec_channel',
      'Recording',
      channelDescription: 'Recording controls',
      importance: Importance.min,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      playSound: false,
      category: AndroidNotificationCategory.service,
      visibility: NotificationVisibility.public,
      // usesChronometer: true,
      // showWhen: true,
      actions: [
        AndroidNotificationAction('pause', 'Pause', showsUserInterface: true),
        AndroidNotificationAction('resume', 'Resume', showsUserInterface: true),
        AndroidNotificationAction('stop', 'Stop', showsUserInterface: true),
      ],
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'recording_category',
      threadIdentifier: 'rec_thread',
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      231,
      title,
      body,
      platformDetails,
      payload: "recording_payload",
    );
  }

  static Future<void> _createRecordingChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'rec_channel',
      'Recording',
      description: 'Recording in progress',
      importance: Importance.min,
      playSound: false,
      enableVibration: false,
      showBadge: false,
    );

    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.createNotificationChannel(channel);
  }

  static Future<void> clear() async {
    await _plugin.cancel(231);
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  log(
    "➡️ BACKGROUND ACTION: actionId=${response.actionId}, payload=${response.payload}",
  );
}
