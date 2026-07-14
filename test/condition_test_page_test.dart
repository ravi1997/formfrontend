import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';
import 'package:formfrontend/features/conditions/presentation/condition_test_page.dart';

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
  bool tested = false;

  _FakeConditionsApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> metadata() async {
    return ApiResult.success({'fields': ['a', 'b']});
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> operatorsMetadata() async {
    return ApiResult.success({'operators': ['=', '!=']});
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> presets() async {
    return ApiResult.success({'presets': [{'name': 'default'}]});
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> testCondition(Map<String, dynamic> payload) async {
    tested = true;
    return ApiResult.success({'passed': true, 'payload': payload});
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Condition test page shows backend summaries and sends test request', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    final api = _FakeConditionsApi();

    await tester.pumpWidget(
      Provider<ConditionsApi>.value(
        value: api,
        child: const MaterialApp(home: ConditionTestPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Conditions'), findsOneWidget);
    expect(find.text('Condition Test'), findsOneWidget);
    expect(find.text('Metadata'), findsOneWidget);
    expect(find.text('Operators'), findsOneWidget);
    expect(find.text('Presets'), findsWidgets);

    await tester.drag(find.byType(ListView), const Offset(0, -800));
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(api.tested, isTrue);
    expect(find.text('Test Result'), findsOneWidget);
    expect(find.text('Passed: true'), findsOneWidget);
  });
}
