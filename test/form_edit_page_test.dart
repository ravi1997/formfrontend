import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/forms/presentation/form_edit_page.dart';

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

class _FakeFormsApi extends FormsApi {
  _FakeFormsApi() : super(_apiClient);

  Map<String, dynamic>? savedPayload;

  @override
  Future<ApiResult<Map<String, dynamic>>> getForm(String projectUuid, String formUuid) async {
    return ApiResult.success({
      'uuid': formUuid,
      'name': 'Original Form',
      'status': 'draft',
      'description': 'Initial description',
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateForm(
    String projectUuid,
    String formUuid,
    Map<String, dynamic> payload,
  ) async {
    savedPayload = payload;
    return ApiResult.success({
      'uuid': formUuid,
      'name': payload['name'] ?? 'Original Form',
      'status': payload['status'] ?? 'draft',
      'description': payload['description'] ?? 'Initial description',
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Form edit shows editable fields and saves backend payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    final api = _FakeFormsApi();

    await tester.pumpWidget(
      Provider<FormsApi>(
        create: (_) => api,
        child: const MaterialApp(
          home: FormEditPage(
            projectUuid: 'p1',
            formUuid: 'f1',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Form Edit'), findsOneWidget);
    expect(find.text('UUID: f1'), findsOneWidget);
    expect(find.text('Loaded payload'), findsOneWidget);
    expect(find.text('Original Form'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Updated Form');
    await tester.enterText(find.byType(TextField).at(1), 'published');
    await tester.enterText(find.byType(TextField).at(2), 'Updated description');
    await tester.scrollUntilVisible(find.text('Save Form'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Save Form'));
    await tester.pumpAndSettle();

    expect(api.savedPayload, isNotNull);
    expect(api.savedPayload!['name'], 'Updated Form');
    expect(api.savedPayload!['status'], 'published');
    expect(api.savedPayload!['description'], 'Updated description');
    expect(find.text('Save result'), findsOneWidget);
    expect(find.textContaining('Updated Form'), findsWidgets);
  });
}
