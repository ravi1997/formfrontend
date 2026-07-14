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
import 'package:formfrontend/features/conditions/data/conditions_api.dart';
import 'package:formfrontend/features/conditions/presentation/condition_versions_page.dart';
import 'package:formfrontend/features/system/data/system_api.dart';
import 'package:formfrontend/features/system/presentation/metrics_page.dart';
import 'package:formfrontend/features/system/presentation/readiness_page.dart';
import 'package:formfrontend/features/system/presentation/schema_echo_page.dart';

class _InMemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write({
    required String key,
    String? value,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    return _values[key];
  }

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    _values.remove(key);
  }
}

final _apiClient = ApiClient(tokenStorage: SecureTokenStorage(storage: _InMemorySecureStorage()));

class _FakeConditionsApi extends ConditionsApi {
  _FakeConditionsApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> metadata() async {
    return ApiResult.success({
      'current_version': 'v2',
      'versions': [
        {'version': 'v2', 'created_at': '2026-07-13'},
        {'version': 'v1', 'created_at': '2026-07-12'},
      ],
    });
  }
}

class _FakeSystemApi extends SystemApi {
  _FakeSystemApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> metrics() async {
    return ApiResult.success({
      'status': 'ok',
      'series': [
        {'name': 'requests', 'value': 12},
      ],
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> readiness() async {
    return ApiResult.success({
      'status': 'ready',
      'checks': [
        {'name': 'db', 'status': 'ok'},
        {'name': 'cache', 'status': 'ok'},
      ],
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> schemaEcho({String? uuid}) async {
    return ApiResult.success({
      'status': 'ok',
      'echo': {'uuid': uuid ?? 'generated'},
    });
  }
}

class _FakeAdminApi extends AdminApi {
  _FakeAdminApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> configHealth() async {
    return ApiResult.success({'status': 'ok'});
  }

  @override
  Future<ApiResult<List<dynamic>>> auditLogs() async {
    return ApiResult.success([
      {'message': 'entry-1'},
    ]);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> rateLimitStatus() async {
    return ApiResult.success({'status': 'ok'});
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Condition versions page shows version summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionVersionsPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Condition Versions'), findsOneWidget);
    expect(find.text('Version Summary'), findsOneWidget);
    expect(find.text('Current version: v2'), findsOneWidget);
    expect(find.text('Recorded versions: 2'), findsOneWidget);
    expect(find.text('Version history'), findsOneWidget);
  });

  testWidgets('Metrics page shows metrics summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<SystemApi>(
        create: (_) => _FakeSystemApi(),
        child: const MaterialApp(home: MetricsPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Metrics'), findsOneWidget);
    expect(find.text('Metrics Summary'), findsOneWidget);
    expect(find.text('Status: ok'), findsOneWidget);
    expect(find.text('Series: 1'), findsOneWidget);
  });

  testWidgets('Readiness page shows readiness summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<SystemApi>(
        create: (_) => _FakeSystemApi(),
        child: const MaterialApp(home: ReadinessPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Readiness'), findsOneWidget);
    expect(find.text('Readiness Summary'), findsOneWidget);
    expect(find.text('Status: ready'), findsOneWidget);
    expect(find.text('Checks: 2'), findsOneWidget);
  });

  testWidgets('Schema echo page shows echo summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<SystemApi>(
        create: (_) => _FakeSystemApi(),
        child: const MaterialApp(home: SchemaEchoPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Schema Echo'), findsOneWidget);
    expect(find.text('Schema Echo Summary'), findsOneWidget);
    expect(find.text('Status: ok'), findsOneWidget);
    expect(find.text('Echo present: yes'), findsOneWidget);
  });

  testWidgets('Admin dashboard shows structured summaries', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<AdminApi>(
        create: (_) => _FakeAdminApi(),
        child: const MaterialApp(home: AdminDashboardPage()),
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
  });
}

