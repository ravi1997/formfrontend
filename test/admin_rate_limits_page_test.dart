import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';
import 'package:formfrontend/features/admin/presentation/admin_rate_limits_page.dart';

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

class _FakeAdminApi extends AdminApi {
  _FakeAdminApi()
      : super(ApiClient(tokenStorage: SecureTokenStorage(storage: _InMemorySecureStorage())));

  @override
  Future<ApiResult<Map<String, dynamic>>> rateLimitStatus() async {
    return ApiResult.success({
      'status': 'green',
      'window': '60s',
      'limit': 100,
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Admin rate limits page shows structured fields', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<AdminApi>(
        create: (_) => _FakeAdminApi(),
        child: const MaterialApp(
          home: AdminRateLimitsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Rate Limits'), findsOneWidget);
    expect(find.text('Rate limit status'), findsOneWidget);
    expect(find.text('status'), findsOneWidget);
    expect(find.text('window'), findsOneWidget);
    expect(find.text('limit'), findsOneWidget);
  });
}
