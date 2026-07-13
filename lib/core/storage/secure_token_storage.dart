import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _sessionUuidKey = 'session_uuid';
  static const _rememberMeKey = 'remember_me';
  static const _savedEmailKey = 'saved_email';

  final FlutterSecureStorage _storage;

  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? sessionUuid,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    if (sessionUuid != null) {
      await _storage.write(key: _sessionUuidKey, value: sessionUuid);
    }
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<String?> getSessionUuid() => _storage.read(key: _sessionUuidKey);

  Future<void> saveRememberMe({required bool remember, String? email}) async {
    await _storage.write(key: _rememberMeKey, value: remember.toString());
    if (remember && email != null) {
      await _storage.write(key: _savedEmailKey, value: email);
    } else {
      await _storage.delete(key: _savedEmailKey);
    }
  }

  Future<bool> getRememberMe() async {
    final value = await _storage.read(key: _rememberMeKey);
    return value == 'true';
  }

  Future<String?> getSavedEmail() => _storage.read(key: _savedEmailKey);

  Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _sessionUuidKey);
  }
}
