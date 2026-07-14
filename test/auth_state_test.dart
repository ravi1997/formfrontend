import 'package:flutter_test/flutter_test.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/errors/api_error.dart';
import 'package:formfrontend/core/state/auth_state.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/core/auth/auth_repository.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _InMemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write({required String key, String? value, AndroidOptions? aOptions, AppleOptions? iOptions, LinuxOptions? lOptions, AppleOptions? mOptions, WebOptions? webOptions, WindowsOptions? wOptions}) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  Future<String?> read({required String key, AndroidOptions? aOptions, AppleOptions? iOptions, LinuxOptions? lOptions, AppleOptions? mOptions, WebOptions? webOptions, WindowsOptions? wOptions}) async {
    return _values[key];
  }

  @override
  Future<void> delete({required String key, AndroidOptions? aOptions, AppleOptions? iOptions, LinuxOptions? lOptions, AppleOptions? mOptions, WebOptions? webOptions, WindowsOptions? wOptions}) async {
    _values.remove(key);
  }
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._meResult);

  final ApiResult<UserProfile> _meResult;

  @override
  Future<ApiResult<AuthResponse>> login({required String email, required String password}) async =>
      ApiResult.success(const AuthResponse(accessToken: 'access', refreshToken: 'refresh'));

  @override
  Future<ApiResult<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    String? designation,
    String? phone,
    String? deviceName,
  }) async =>
      ApiResult.success(const AuthResponse(accessToken: 'access', refreshToken: 'refresh'));

  @override
  Future<ApiResult<void>> logout() async => ApiResult.success(null);

  @override
  Future<ApiResult<UserProfile>> getMe() async => _meResult;

  @override
  Future<ApiResult<List<SessionInfo>>> getSessions() async => ApiResult.success(<SessionInfo>[]);

  @override
  Future<ApiResult<void>> revokeSession(String sessionUuid) async => ApiResult.success(null);

  @override
  Future<ApiResult<void>> logoutAll({bool keepCurrent = true}) async => ApiResult.success(null);
}

void main() {
  test('AuthStateNotifier clears stored credentials on unauthorized me check', () async {
    final storage = SecureTokenStorage(storage: _InMemorySecureStorage());
    await storage.saveTokens(accessToken: 'access', refreshToken: 'refresh', sessionUuid: 'session-1');

    final notifier = AuthStateNotifier(
      authRepository: _FakeAuthRepository(
        ApiResult.failure(
          const ApiError(message: 'Unauthorized', statusCode: 401),
        ),
      ),
      tokenStorage: storage,
    );

    await notifier.checkAuthStatus();

    expect(notifier.status, AuthStatus.unauthenticated);
    expect(await storage.getAccessToken(), isNull);
    expect(await storage.getRefreshToken(), isNull);
    expect(await storage.getSessionUuid(), isNull);
  });
}
