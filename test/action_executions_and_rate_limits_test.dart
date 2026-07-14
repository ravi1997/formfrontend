import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';
import 'package:formfrontend/features/responses/data/responses_api.dart';
import 'package:formfrontend/features/responses/presentation/action_executions_page.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';
import 'package:formfrontend/features/admin/presentation/admin_rate_limits_page.dart';

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
}

class _FakeSectionsApi extends SectionsApi {
  _FakeSectionsApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listSections({
    required String projectUuid,
    required String formUuid,
  }) async {
    return ApiResult.success([
      {'uuid': 's1', 'name': 'Section 1'},
    ]);
  }
}

class _FakeQuestionsApi extends QuestionsApi {
  _FakeQuestionsApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listQuestions({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) async {
    return ApiResult.success([
      {'uuid': 'q1', 'name': 'Question 1'},
    ]);
  }
}

class _FakeChoicesApi extends ChoicesApi {
  _FakeChoicesApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listChoices({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) async {
    return ApiResult.success([
      {'uuid': 'c1', 'name': 'Choice 1'},
    ]);
  }
}

class _FakeResponsesApi extends ResponsesApi {
  _FakeResponsesApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> listActionExecutions({
    required String projectUuid,
    required String formUuid,
    required String responseUuid,
  }) async {
    return ApiResult.success({
      'status': 'ok',
      'executions': [
        {'action': 'send_email', 'result': 'sent'},
      ],
    });
  }
}

class _FakeAdminApi extends AdminApi {
  _FakeAdminApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> rateLimitStatus() async {
    return ApiResult.success({
      'status': 'green',
      'requests_per_minute': 120,
      'burst': 20,
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Action executions page shows execution payload summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProjectsApi>(create: (_) => _FakeProjectsApi()),
          Provider<FormsApi>(create: (_) => _FakeFormsApi()),
          Provider<SectionsApi>(create: (_) => _FakeSectionsApi()),
          Provider<QuestionsApi>(create: (_) => _FakeQuestionsApi()),
          Provider<ChoicesApi>(create: (_) => _FakeChoicesApi()),
          Provider<ResponsesApi>(create: (_) => _FakeResponsesApi()),
        ],
        child: const MaterialApp(home: ActionExecutionsPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Action Executions'), findsWidgets);
    expect(find.text('Execution payload'), findsNothing);
  });

  testWidgets('Admin rate limits page shows structured status cards', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<AdminApi>(
        create: (_) => _FakeAdminApi(),
        child: const MaterialApp(home: AdminRateLimitsPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Rate Limits'), findsOneWidget);
    expect(find.text('Rate limit status'), findsOneWidget);
    expect(find.text('green · 3 fields returned'), findsOneWidget);
    expect(find.text('Type: String'), findsWidgets);
  });
}

