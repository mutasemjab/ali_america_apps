import 'package:LaEsperanza/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/services/fcm_token_sync_service.dart';
import 'core/services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Must be registered before runApp, at top level, so it works even if
    // the app process was killed and a push wakes it back up.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    // Push notifications are best-effort — a platform without Firebase
    // configured (or no config at all) shouldn't stop the app from booting.
    debugPrint('Firebase.initializeApp failed: $e');
  }

  await initDependencies();
  sl<FcmTokenSyncService>().start();
  await sl<PushNotificationService>().init();

  runApp(const StoreCompanionApp());
}
