import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';
import 'package:formfrontend/features/admin/presentation/admin_config_health_page.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';
import 'package:formfrontend/features/conditions/presentation/condition_batch_test_page.dart';
import 'package:formfrontend/features/conditions/presentation/condition_presets_page.dart';

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
  Future<ApiResult<Map<String, dynamic>>> testBatchConditions(Map<String, dynamic> payload) async {
    return ApiResult.success({
      'batch': [
        {'condition': 'sample', 'passed': true},
      ],
      'summary': {'passed': 1, 'failed': 0},
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> presets() async {
    return ApiResult.success({
      'presets': [
        {'name': 'Default preset', 'slug': 'default'},
        {'name': 'Release preset', 'slug': 'release'},
      ],
      'import_supported': true,
      'export_supported': true,
    });
  }
}

class _FakeAdminApi extends AdminApi {
  _FakeAdminApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> configHealth() async {
    return ApiResult.success({
      'status': 'ok',
      'checks': [
        {'name': 'db', 'status': 'ok'},
        {'name': 'cache', 'status': 'ok'},
      ],
      'warnings': [
        {'message': 'none'},
      ],
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Condition batch test page shows response summary after submit', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionBatchTestPage()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Run Batch Test'));
    await tester.pumpAndSettle();

    expect(find.text('Batch payload'), findsOneWidget);
    expect(find.text('Batch response'), findsOneWidget);
    expect(find.text('Batch response received'), findsOneWidget);
    expect(find.textContaining('summary'), findsWidgets);
  });

  testWidgets('Condition presets page shows summary and first preset', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionPresetsPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Condition Presets'), findsOneWidget);
    expect(find.text('Preset Summary'), findsOneWidget);
    expect(find.text('Preset count: 2'), findsOneWidget);
    expect(find.text('Import supported: true'), findsOneWidget);
    expect(find.text('Export supported: true'), findsOneWidget);
    expect(find.text('First preset'), findsOneWidget);
  });

  testWidgets('Admin config health page shows status summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<AdminApi>(
        create: (_) => _FakeAdminApi(),
        child: const MaterialApp(home: AdminConfigHealthPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Config Health'), findsOneWidget);
    expect(find.text('Config Health Summary'), findsOneWidget);
    expect(find.text('Status: ok'), findsOneWidget);
    expect(find.text('Checks: 2'), findsOneWidget);
    expect(find.text('Warnings: 1'), findsOneWidget);
  });
}

