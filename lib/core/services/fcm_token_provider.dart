import 'package:firebase_messaging/firebase_messaging.dart';

/// Thin wrapper around [FirebaseMessaging.instance.getToken] — never throws,
/// never blocks a request waiting on it. Callers just get `null` when a
/// token isn't available yet (permission denied, Firebase not configured
/// on this platform, etc) and proceed without it.
class FcmTokenProvider {
  FcmTokenProvider._();

  static Future<String?> current() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }
}
