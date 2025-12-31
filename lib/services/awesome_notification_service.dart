import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AwesomeNotificationService {
  // Singleton
  static final AwesomeNotificationService _instance =
      AwesomeNotificationService._internal();
  factory AwesomeNotificationService() => _instance;
  AwesomeNotificationService._internal();

  /// Initialize Awesome Notifications
  Future<void> init() async {
    await AwesomeNotifications().initialize(
      null, // set null to use default icon
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: const Color(0xFFFFFFFF),
          importance: NotificationImportance.High,
        ),
      ],
      debug: true,
    );

    // Request notification permission (required on iOS)
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  /// Show notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        payload: payload != null ? {'payload': payload} : null,
      ),
    );
  }

  // SUBSCRIBE to a topic
  static Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print("Subscribed to topic: $topic");
  }

  // UNSUBSCRIBE from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    print("Unsubscribed from topic: $topic");
  }
}
