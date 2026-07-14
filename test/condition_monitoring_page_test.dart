import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';
import 'package:formfrontend/features/conditions/presentation/condition_monitoring_page.dart';

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

class _FakeConditionsApi extends ConditionsApi {
  _FakeConditionsApi()
      : super(ApiClient(tokenStorage: SecureTokenStorage(storage: _InMemorySecureStorage())));

  @override
  Future<ApiResult<Map<String, dynamic>>> monitoringGraph() async {
    return ApiResult.success({
      'graph': {'nodes': 3, 'edges': 2},
      'evaluation_stats': {'passed': 10, 'failed': 1},
      'heatmap': {'hot': 2},
      'unused': ['cond-1'],
      'most_used': ['cond-2'],
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Condition monitoring page shows labeled monitoring sections', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ConditionsApi>(
        create: (_) => _FakeConditionsApi(),
        child: const MaterialApp(
          home: ConditionMonitoringPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Condition Monitoring'), findsOneWidget);
    expect(find.text('Monitoring Summary'), findsOneWidget);
    expect(find.text('Graph Snapshot'), findsOneWidget);
    expect(find.text('Evaluation Stats'), findsOneWidget);
    expect(find.text('Heatmap'), findsOneWidget);
    expect(find.text('Unused Conditions'), findsOneWidget);
  });
}
