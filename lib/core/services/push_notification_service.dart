import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'General',
  description: 'Deals, coupons, and store updates.',
  importance: Importance.high,
);

final _localNotifications = FlutterLocalNotificationsPlugin();

/// Runs in a separate isolate when a push arrives while the app is fully
/// backgrounded/terminated, so it needs its own Firebase init. A
/// "notification"-shaped payload is already auto-displayed by the OS at
/// this point — this only needs to handle data-only payloads.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null) return;
  await _showLocalNotification(message);
}

Future<void> _showLocalNotification(RemoteMessage message) async {
  final title = message.data['title'] as String? ?? message.notification?.title;
  final body = message.data['body'] as String? ?? message.notification?.body;
  if (title == null && body == null) return;

  await _localNotifications.show(
    id: message.hashCode,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}

/// Requests notification permission (this is what actually triggers the OS
/// prompt — declaring the manifest permission alone does not), sets up the
/// notification channel Android needs to display anything, and shows a
/// local notification for pushes that arrive while the app is in the
/// foreground (Android never auto-displays those on its own).
class PushNotificationService {
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        ),
      );

      FirebaseMessaging.onMessage.listen(_showLocalNotification);
    } catch (e) {
      // Best-effort: a platform without Firebase configured, or a denied
      // permission, shouldn't affect anything else in the app.
      debugPrint('PushNotificationService.init failed: $e');
    }
  }
}
