import 'package:flutter/foundation.dart';

import '../storage/secure_storage_service.dart';

/// Single source of truth for "does this device have a valid session".
/// Read by the router (guest vs. authenticated routing) and by the dio
/// interceptor (attach token / clear on 401). A [ChangeNotifier] so
/// go_router's `refreshListenable` can react to login/logout instantly.
class AuthSession extends ChangeNotifier {
  final SecureStorageService _secureStorage;

  String? _token;
  bool _initialized = false;

  AuthSession(this._secureStorage);

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  bool get isInitialized => _initialized;

  String? get token => _token;

  Future<void> restore() async {
    _token = await _secureStorage.readToken();
    _initialized = true;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _token = token;
    await _secureStorage.saveToken(token);
    notifyListeners();
  }

  Future<void> clear() async {
    _token = null;
    await _secureStorage.deleteToken();
    notifyListeners();
  }
}
