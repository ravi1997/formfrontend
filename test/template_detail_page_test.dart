import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/ui_templates/data/ui_templates_api.dart';
import 'package:formfrontend/features/ui_templates/presentation/template_detail_page.dart';

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

class _FakeUiTemplatesApi extends UiTemplatesApi {
  _FakeUiTemplatesApi()
      : super(ApiClient(tokenStorage: SecureTokenStorage(storage: _InMemorySecureStorage())));

  @override
  Future<ApiResult<Map<String, dynamic>>> getThemeTemplate(String templateUuid) async {
    return ApiResult.success({
      'uuid': templateUuid,
      'name': 'Theme $templateUuid',
      'revision': '1.0.0',
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Template detail page renders fetched template payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<UiTemplatesApi>(
        create: (_) => _FakeUiTemplatesApi(),
        child: const MaterialApp(
          home: TemplateDetailPage.theme(templateUuid: 'template-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Theme Template Detail'), findsOneWidget);
    expect(find.text('Theme Template Summary'), findsOneWidget);
    expect(find.text('Name: Theme template-1'), findsOneWidget);
    expect(find.text('Version: 1.0.0'), findsOneWidget);
    expect(find.textContaining('template-1'), findsWidgets);
  });
}
