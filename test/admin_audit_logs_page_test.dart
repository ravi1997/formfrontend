import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';
import 'package:formfrontend/features/admin/presentation/admin_audit_logs_page.dart';

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
  Future<ApiResult<List<dynamic>>> auditLogs() async {
    return ApiResult.success([
      {
        'message': 'created form',
        'actor': 'user-1',
        'target': 'form-1',
        'created_at': '2026-07-13T10:00:00Z',
      },
      {
        'action': 'published template',
        'user': 'user-2',
        'resource': 'template-1',
        'timestamp': '2026-07-13T10:05:00Z',
      },
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Admin audit logs page shows structured entries', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<AdminApi>(
        create: (_) => _FakeAdminApi(),
        child: const MaterialApp(
          home: AdminAuditLogsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Audit Logs'), findsOneWidget);
    expect(find.text('created form'), findsOneWidget);
    expect(find.text('published template'), findsOneWidget);
    expect(find.text('Actor: user-1'), findsOneWidget);
    expect(find.text('Target: template-1'), findsOneWidget);
  });
}
