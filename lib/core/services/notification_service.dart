import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/logger.dart';

/// Top-level FCM background handler. Must be a top-level (or static) function
/// per firebase_messaging requirements. Kept intentionally minimal — heavy
/// work happens in the workmanager auto-apply task.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No-op: the data payload is handled when the app/background task wakes.
}

/// Initialises FCM + local notifications and exposes a simple `show` API.
class NotificationService {
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _local = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _local;
  final AppLogger _log = AppLogger('Notifications');

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ipo_alerts',
    'IPO alerts',
    description: 'Notifies when an IPO opens, is applied for, or results are out',
    importance: Importance.high,
  );

  /// Call once during startup. [initFirebase] can be disabled in tests or
  /// when Firebase config is absent.
  Future<void> init({bool initFirebase = true}) async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    if (initFirebase) {
      try {
        await FirebaseMessaging.instance.requestPermission();
        FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler,
        );
        FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      } catch (e) {
        _log.w('FCM unavailable (config missing?): $e');
      }
    }
  }

  Future<String?> fcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    if (n != null) show(title: n.title ?? 'IPO update', body: n.body ?? '');
  }

  Future<void> show({required String title, required String body}) async {
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
    if (kDebugMode) _log.d('shown: $title');
  }
}
