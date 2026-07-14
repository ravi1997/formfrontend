import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
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

class _FakeSystemApi extends SystemApi {
  _FakeSystemApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> metrics() async {
    return ApiResult.success({
      'status': 'ok',
      'series': [
        {'name': 'requests', 'value': 12},
      ],
      'source': 'backend',
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> readiness() async {
    return ApiResult.success({
      'status': 'ready',
      'checks': [
        {'name': 'db'},
      ],
      'source': 'backend',
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> schemaEcho({String? uuid}) async {
    return ApiResult.success({
      'status': 'ok',
      'echo': {'uuid': uuid ?? 'generated'},
      'source': 'backend',
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Metrics page shows structured payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<SystemApi>(
        create: (_) => _FakeSystemApi(),
        child: const MaterialApp(home: MetricsPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Metrics Summary'), findsOneWidget);
    expect(find.text('Status: ok'), findsOneWidget);
    expect(find.text('Series: 1'), findsOneWidget);
    expect(find.text('Source: backend'), findsOneWidget);
    expect(find.text('Metrics payload'), findsOneWidget);
  });

  testWidgets('Readiness page shows structured payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<SystemApi>(
        create: (_) => _FakeSystemApi(),
        child: const MaterialApp(home: ReadinessPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Readiness Summary'), findsOneWidget);
    expect(find.text('Status: ready'), findsOneWidget);
    expect(find.text('Checks: 1'), findsOneWidget);
    expect(find.text('Source: backend'), findsOneWidget);
    expect(find.text('Readiness payload'), findsOneWidget);
  });

  testWidgets('Schema echo page shows structured payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<SystemApi>(
        create: (_) => _FakeSystemApi(),
        child: const MaterialApp(home: SchemaEchoPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Schema Echo Summary'), findsOneWidget);
    expect(find.text('Status: ok'), findsOneWidget);
    expect(find.text('Echo present: yes'), findsOneWidget);
    expect(find.text('Source: backend'), findsOneWidget);
    expect(find.text('Schema payload'), findsOneWidget);
  });
}

