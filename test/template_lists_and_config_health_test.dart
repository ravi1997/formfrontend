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
import 'package:formfrontend/features/ui_templates/data/ui_templates_api.dart';
import 'package:formfrontend/features/ui_templates/presentation/layout_templates_page.dart';
import 'package:formfrontend/features/ui_templates/presentation/theme_templates_page.dart';

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

class _FakeUiTemplatesApi extends UiTemplatesApi {
  _FakeUiTemplatesApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listThemeTemplates() async {
    return ApiResult.success([
      {'uuid': 't1', 'name': 'Theme One'},
      {'uuid': 't2', 'name': 'Theme Two'},
    ]);
  }

  @override
  Future<ApiResult<List<dynamic>>> listLayoutTemplates() async {
    return ApiResult.success([
      {'uuid': 'l1', 'name': 'Layout One'},
    ]);
  }
}

class _FakeAdminApi extends AdminApi {
  _FakeAdminApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> configHealth() async {
    return ApiResult.success({
      'status': 'ok',
      'checks': [
        {'name': 'db'},
      ],
      'warnings': [],
      'source': 'backend',
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Theme templates page shows summary cards', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<UiTemplatesApi>(
        create: (_) => _FakeUiTemplatesApi(),
        child: const MaterialApp(home: ThemeTemplatesPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Theme Templates'), findsWidgets);
    expect(find.text('Template count: 2'), findsOneWidget);
    expect(find.text('Template 1'), findsOneWidget);
    expect(find.text('Template 2'), findsOneWidget);
  });

  testWidgets('Layout templates page shows summary cards', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<UiTemplatesApi>(
        create: (_) => _FakeUiTemplatesApi(),
        child: const MaterialApp(home: LayoutTemplatesPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Layout Templates'), findsWidgets);
    expect(find.text('Template count: 1'), findsOneWidget);
    expect(find.text('Template 1'), findsOneWidget);
  });

  testWidgets('Admin config health page shows config summary', (tester) async {
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
    expect(find.text('Source: backend'), findsOneWidget);
    expect(find.text('Config payload'), findsOneWidget);
  });
}
