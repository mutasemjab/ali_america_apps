import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper around secure storage — the only place the auth token
/// touches disk. Never persisted via SharedPreferences.
class SecureStorageService {
  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);
}
