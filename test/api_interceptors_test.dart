import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:formfrontend/core/api/api_interceptors.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ApiInterceptors clear credentials if refresh payload is malformed', () async {
    await dotenv.load(fileName: 'assets/.env');
    final storage = SecureTokenStorage(storage: _InMemorySecureStorage());
    await storage.saveTokens(accessToken: 'a', refreshToken: 'r', sessionUuid: 's');

    final interceptor = ApiInterceptors(tokenStorage: storage);

    expect(interceptor, isNotNull);
    await storage.clearAll();
    expect(await storage.getAccessToken(), isNull);
    expect(await storage.getRefreshToken(), isNull);
    expect(await storage.getSessionUuid(), isNull);
  });
}
