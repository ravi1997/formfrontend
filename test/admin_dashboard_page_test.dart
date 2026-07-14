import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';
import 'package:formfrontend/features/admin/presentation/admin_dashboard_page.dart';

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
  Future<ApiResult<Map<String, dynamic>>> configHealth() async {
    return ApiResult.success({'status': 'ok', 'checks': [1, 2]});
  }

  @override
  Future<ApiResult<List<dynamic>>> auditLogs() async {
    return ApiResult.success([
      {'message': 'audit-1'},
    ]);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> rateLimitStatus() async {
    return ApiResult.success({'status': 'green', 'burst': 20});
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Admin dashboard shows backend status chips and summaries', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<AdminApi>(
        create: (_) => _FakeAdminApi(),
        child: const MaterialApp(
          home: AdminDashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Admin Dashboard'), findsOneWidget);
    expect(find.text('Config healthy'), findsOneWidget);
    expect(find.text('Audit logs loaded'), findsOneWidget);
    expect(find.text('Rate limits loaded'), findsOneWidget);
    expect(find.text('Config Health'), findsOneWidget);
    expect(find.text('Audit Logs'), findsOneWidget);
    expect(find.text('Rate Limit Status'), findsOneWidget);
    expect(find.text('Checks: 2'), findsOneWidget);
    expect(find.text('Entries: 1'), findsOneWidget);
    expect(find.text('Fields: 2'), findsOneWidget);
  });
}
