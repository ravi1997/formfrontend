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
      'approved_count': 4,
      'pending_count': 1,
      'can_approve': true,
      'job_id': 'job-1',
      'eta': '5s',
      'result': {'condition': 'sample', 'passed': true},
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Condition approval page shows summary and action intent', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionApprovalPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Condition Approval'), findsOneWidget);
    expect(find.text('Approval Summary'), findsOneWidget);
    expect(find.text('Status: ready'), findsOneWidget);
    expect(find.text('Approved: 4'), findsOneWidget);
    expect(find.text('Pending: 1'), findsOneWidget);
    expect(find.text('Can approve: true'), findsOneWidget);
    expect(find.text('Approval actions'), findsOneWidget);
  });

  testWidgets('Condition async page shows job summary and action hint', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(home: ConditionAsyncPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Condition Async'), findsOneWidget);
    expect(find.text('Async Job Summary'), findsOneWidget);
    expect(find.text('Job ID: job-1'), findsOneWidget);
    expect(find.text('Status: ready'), findsOneWidget);
    expect(find.text('ETA: 5s'), findsOneWidget);
    expect(find.text('Result: {condition: sample, passed: true}'), findsOneWidget);
    expect(find.text('Async actions'), findsOneWidget);
  });
}

