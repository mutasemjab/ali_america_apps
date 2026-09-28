import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../features/profile/domain/usecases/get_me_usecase.dart';
import '../../features/profile/domain/usecases/update_me_usecase.dart';
import '../session/auth_session.dart';
import '../usecase/usecase.dart';

/// Firebase can rotate the device's FCM token at any time — that's normal,
/// not an error condition. This keeps the backend's copy in sync by pushing
/// every refreshed token through PUT /me, silently, while the user is
/// logged in. Nothing happens (and nothing is shown to the user) if they're
/// browsing as a guest.
class FcmTokenSyncService {
  final AuthSession _authSession;
  final GetMeUseCase _getMeUseCase;
  final UpdateMeUseCase _updateMeUseCase;

  StreamSubscription<String>? _subscription;

  FcmTokenSyncService(this._authSession, this._getMeUseCase, this._updateMeUseCase);

  void start() {
    _subscription ??= FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefreshed);
  }

  Future<void> _onTokenRefreshed(String newToken) async {
    if (!_authSession.isAuthenticated) return;

    final meResult = await _getMeUseCase(const NoParams());
    await meResult.fold(
      (_) async {}, // couldn't load the current profile — skip this round silently
      (client) async {
        await _updateMeUseCase(
          UpdateMeParams(name: client.name, email: client.email, fcmToken: newToken),
        );
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
