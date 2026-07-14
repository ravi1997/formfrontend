import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/responses/data/responses_api.dart';
import 'package:formfrontend/features/responses/presentation/response_submission_page.dart';

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

class _FakeProjectsApi extends ProjectsApi {
  _FakeProjectsApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listProjects() async {
    return ApiResult.success([
      {'uuid': 'p1', 'name': 'Project 1'},
    ]);
  }
}

class _FakeFormsApi extends FormsApi {
  _FakeFormsApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listForms(String projectUuid) async {
    return ApiResult.success([
      {'uuid': 'f1', 'name': 'Form 1'},
    ]);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getEffectiveUi(String projectUuid, String formUuid) async {
    return ApiResult.success({
      'fields': [
        {'key': 'sample', 'label': 'Sample', 'type': 'text'},
      ],
    });
  }
}

class _FakeResponsesApi extends ResponsesApi {
  bool submitted = false;
  Map<String, dynamic>? lastPayload;

  _FakeResponsesApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> submitResponse({
    required String projectUuid,
    required String formUuid,
    required Map<String, dynamic> payload,
  }) async {
    submitted = true;
    lastPayload = payload;
    return ApiResult.success({
      'projectUuid': projectUuid,
      'formUuid': formUuid,
      'payload': payload,
      'status': 'submitted',
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Response submission page shows submission result', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    final responsesApi = _FakeResponsesApi();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProjectsApi>(create: (_) => _FakeProjectsApi()),
          Provider<FormsApi>(create: (_) => _FakeFormsApi()),
          Provider<ResponsesApi>.value(value: responsesApi),
        ],
        child: const MaterialApp(home: ResponseSubmissionPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Response Submission'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));

    final dropdowns = find.byType(DropdownButtonFormField<String>);

    await tester.ensureVisible(dropdowns.first);
    await tester.tap(dropdowns.first);
    await tester.pump();
    await tester.tap(find.text('Project 1').last);
    await tester.pump();

    await tester.ensureVisible(dropdowns.last);
    await tester.tap(dropdowns.last);
    await tester.pump();
    await tester.tap(find.text('Form 1').last);
    await tester.pump();

    expect(find.text('Submit'), findsOneWidget);

    await tester.ensureVisible(find.text('Submit'));
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(responsesApi.submitted, isTrue);
    expect(responsesApi.lastPayload, isNotNull);
    expect(responsesApi.lastPayload!['effective_ui'], isNotNull);
  });
}
