import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/ui_templates/data/ui_templates_api.dart';
import 'package:formfrontend/features/ui_templates/presentation/template_form_page.dart';

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

final _apiClient = ApiClient(
  tokenStorage: SecureTokenStorage(storage: _InMemorySecureStorage()),
);

class _FakeUiTemplatesApi extends UiTemplatesApi {
  _FakeUiTemplatesApi() : super(_apiClient);
}

void main() {
  testWidgets('Template form creates backend-shaped payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    final api = _FakeUiTemplatesApi();

    await tester.pumpWidget(
      Provider<UiTemplatesApi>.value(
        value: api,
        child: const MaterialApp(
          home: TemplateFormPage(
            isThemeTemplate: true,
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Create Theme Template'), findsOneWidget);
    expect(find.byType(TextField), findsAtLeastNWidgets(5));
  });
}
