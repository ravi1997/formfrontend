import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';
import 'package:formfrontend/features/conditions/presentation/condition_approval_page.dart';
import 'package:formfrontend/features/conditions/presentation/condition_async_page.dart';
import 'package:formfrontend/features/conditions/presentation/condition_presets_page.dart';
import 'package:formfrontend/features/conditions/presentation/condition_versions_page.dart';

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
      'status': 'ready',
      'current_version': 'v2',
      'versions': [
        {'version': 'v2'},
        {'version': 'v1'},
      ],
      'approved_count': 3,
      'pending_count': 1,
      'can_approve': true,
      'transition_target': 'published',
      'job_id': 'job-7',
      'eta': '4s',
      'progress': 80,
      'result': {'ok': true},
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> presets() async {
    return ApiResult.success({
      'presets': [
        {'name': 'Default'},
      ],
      'import_supported': true,
      'export_supported': true,
      'source': 'backend',
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Condition approval page shows action summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionApprovalPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Approval Summary'), findsOneWidget);
    expect(find.text('Transition target: published'), findsOneWidget);
    expect(find.text('Transition'), findsOneWidget);
    expect(find.text('Rollback'), findsOneWidget);
  });

  testWidgets('Condition versions page shows version summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionVersionsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Version Summary'), findsOneWidget);
    expect(find.text('Current version: v2'), findsOneWidget);
    expect(find.text('Recorded versions: 2'), findsOneWidget);
    expect(find.text('Recorded count: Unknown'), findsOneWidget);
    expect(find.text('Version payload'), findsOneWidget);
  });

  testWidgets('Condition presets page shows source summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionPresetsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Preset Summary'), findsOneWidget);
    expect(find.text('Preset count: 1'), findsOneWidget);
    expect(find.text('Import supported: true'), findsOneWidget);
    expect(find.text('Export supported: true'), findsOneWidget);
    expect(find.text('Source: backend'), findsOneWidget);
    expect(find.text('Preset payload'), findsOneWidget);
  });

  testWidgets('Condition async page shows job summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionAsyncPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Async Job Summary'), findsOneWidget);
    expect(find.text('Job ID: job-7'), findsOneWidget);
    expect(find.text('Status: ready'), findsOneWidget);
    expect(find.text('Progress: 80'), findsOneWidget);
    expect(find.text('Async payload'), findsOneWidget);
  });
}

