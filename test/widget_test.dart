import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/app/app.dart';
import 'package:formfrontend/app/shell/main_shell.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';
import 'package:formfrontend/features/conditions/data/conditions_api.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';
import 'package:formfrontend/features/responses/data/responses_api.dart';
import 'package:formfrontend/features/responses/presentation/response_submission_page.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';
import 'package:formfrontend/features/ui_templates/data/ui_templates_api.dart';
import 'package:formfrontend/features/system/data/system_api.dart';
import 'package:formfrontend/features/workflows/data/workflows_api.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/core/auth/auth_repository.dart';
import 'package:formfrontend/core/state/current_user_state.dart';
import 'package:formfrontend/core/state/session_state.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FakeSecureTokenStorage extends SecureTokenStorage {
  final Map<String, String> _data = {};

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? sessionUuid,
  }) async {
    _data['access_token'] = accessToken;
    _data['refresh_token'] = refreshToken;
    if (sessionUuid != null) _data['session_uuid'] = sessionUuid;
  }

  @override
  Future<String?> getAccessToken() async => _data['access_token'];

  @override
  Future<String?> getRefreshToken() async => _data['refresh_token'];

  @override
  Future<String?> getSessionUuid() async => _data['session_uuid'];

  @override
  Future<void> clearAll() async => _data.clear();
}

final ApiClient _dummyApiClient = ApiClient(tokenStorage: FakeSecureTokenStorage());

class FakeAuthRepository implements AuthRepository {
  @override
  Future<ApiResult<AuthResponse>> login({required String email, required String password}) async =>
      ApiResult.success(const AuthResponse(accessToken: 'a', refreshToken: 'r'));

  @override
  Future<ApiResult<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    String? designation,
    String? phone,
    String? deviceName,
  }) async =>
      ApiResult.success(const AuthResponse(accessToken: 'a', refreshToken: 'r'));

  @override
  Future<ApiResult<void>> logout() async => ApiResult.success(null);

  @override
  Future<ApiResult<UserProfile>> getMe() async => ApiResult.success(
        const UserProfile(uuid: 'u', email: 'u@example.com', name: 'User', roles: []),
      );

  @override
  Future<ApiResult<List<SessionInfo>>> getSessions() async => ApiResult.success(<SessionInfo>[]);

  @override
  Future<ApiResult<void>> revokeSession(String sessionUuid) async => ApiResult.success(null);

  @override
  Future<ApiResult<void>> logoutAll({bool keepCurrent = true}) async => ApiResult.success(null);
}

class FakeProjectsApi extends ProjectsApi {
  FakeProjectsApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<List<dynamic>>> listProjects() async => ApiResult.success([
        {'uuid': 'p1', 'name': 'Project 1'},
      ]);
}

class FakeFormsApi extends FormsApi {
  FakeFormsApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<List<dynamic>>> listForms(String projectUuid) async => ApiResult.success([
        {'uuid': 'f1', 'name': 'Form 1'},
      ]);

  @override
  Future<ApiResult<Map<String, dynamic>>> getEffectiveUi(String projectUuid, String formUuid) async =>
      ApiResult.success({
        'fields': [
          {
            'key': 'age',
            'label': 'Age',
            'type': 'integer',
            'required': true,
            'placeholder': 'Enter age',
          },
          {
            'key': 'notes',
            'label': 'Notes',
            'type': 'textarea',
          },
        ],
      });
}

class FakeSectionsApi extends SectionsApi {
  FakeSectionsApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<List<dynamic>>> listSections({
    required String projectUuid,
    required String formUuid,
  }) async => ApiResult.success(<dynamic>[]);
}

class FakeQuestionsApi extends QuestionsApi {
  FakeQuestionsApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<List<dynamic>>> listQuestions({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) async => ApiResult.success(<dynamic>[]);
}

class FakeChoicesApi extends ChoicesApi {
  FakeChoicesApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<List<dynamic>>> listChoices({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) async => ApiResult.success(<dynamic>[]);
}

class FakeConditionsApi extends ConditionsApi {
  FakeConditionsApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> metadata() async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> operatorsMetadata() async =>
      ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> testCondition(Map<String, dynamic> payload) async =>
      ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> testBatchConditions(Map<String, dynamic> payload) async =>
      ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> monitoringGraph() async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> presets() async => ApiResult.success(<String, dynamic>{});
}

class FakeAdminApi extends AdminApi {
  FakeAdminApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> configHealth() async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<List<dynamic>>> auditLogs() async => ApiResult.success(<dynamic>[]);

  @override
  Future<ApiResult<List<dynamic>>> rateLimitLogs() async => ApiResult.success(<dynamic>[]);

  @override
  Future<ApiResult<Map<String, dynamic>>> rateLimitStatus() async => ApiResult.success(<String, dynamic>{});
}

class FakeSystemApi extends SystemApi {
  FakeSystemApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> health() async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> readiness() async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> metrics() async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> schemaEcho({String? uuid}) async => ApiResult.success(<String, dynamic>{});
}

class FakeUiTemplatesApi extends UiTemplatesApi {
  FakeUiTemplatesApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<List<dynamic>>> listThemeTemplates() async => ApiResult.success(<dynamic>[]);

  @override
  Future<ApiResult<List<dynamic>>> listLayoutTemplates() async => ApiResult.success(<dynamic>[]);

  @override
  Future<ApiResult<Map<String, dynamic>>> getThemeTemplate(String templateUuid) async =>
      ApiResult.success(<String, dynamic>{'uuid': templateUuid});

  @override
  Future<ApiResult<Map<String, dynamic>>> getLayoutTemplate(String templateUuid) async =>
      ApiResult.success(<String, dynamic>{'uuid': templateUuid});
}

class FakeWorkflowsApi extends WorkflowsApi {
  FakeWorkflowsApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> submitWorkflow({
    required String projectUuid,
    required String formUuid,
    Map<String, dynamic>? payload,
  }) async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> reviewWorkflow({
    required String projectUuid,
    required String formUuid,
    Map<String, dynamic>? payload,
  }) async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> approveWorkflow({
    required String projectUuid,
    required String formUuid,
    Map<String, dynamic>? payload,
  }) async => ApiResult.success(<String, dynamic>{});
}

class FakeResponsesApi extends ResponsesApi {
  FakeResponsesApi() : super(_dummyApiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> submitResponse({
    required String projectUuid,
    required String formUuid,
    required Map<String, dynamic> payload,
  }) async => ApiResult.success(<String, dynamic>{});

  @override
  Future<ApiResult<Map<String, dynamic>>> listActionExecutions({
    required String projectUuid,
    required String formUuid,
    required String responseUuid,
  }) async => ApiResult.success(<String, dynamic>{});
}

void main() {
  testWidgets('Smoke test for A.D.I.Y.O.G.I App', (WidgetTester tester) async {
    // Set screen size for test environment to initialize responsive sizer properly
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await dotenv.load(fileName: 'assets/.env');
    final fakeStorage = FakeSecureTokenStorage();

    // Build our app with injected fake storage
    await tester.pumpWidget(App(tokenStorage: fakeStorage));
    
    // Pump frames to complete async auth check
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify that the login page brand name is rendered.
    expect(find.text('A.D.I.Y.O.G.I'), findsWidgets);
  });

  testWidgets('Main shell exposes backend domain navigation', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CurrentUserState>(create: (_) => CurrentUserState()),
          ChangeNotifierProvider<SessionStateNotifier>(
            create: (_) => SessionStateNotifier(authRepository: FakeAuthRepository()),
          ),
          Provider<ProjectsApi>(create: (_) => FakeProjectsApi()),
          Provider<FormsApi>(create: (_) => FakeFormsApi()),
          Provider<SectionsApi>(create: (_) => FakeSectionsApi()),
          Provider<QuestionsApi>(create: (_) => FakeQuestionsApi()),
          Provider<ChoicesApi>(create: (_) => FakeChoicesApi()),
          Provider<ConditionsApi>(create: (_) => FakeConditionsApi()),
          Provider<AdminApi>(create: (_) => FakeAdminApi()),
          Provider<UiTemplatesApi>(create: (_) => FakeUiTemplatesApi()),
          Provider<SystemApi>(create: (_) => FakeSystemApi()),
          Provider<WorkflowsApi>(create: (_) => FakeWorkflowsApi()),
          Provider<ResponsesApi>(create: (_) => FakeResponsesApi()),
        ],
        child: const MaterialApp(
          home: MainShell(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold).first);
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Forms'), findsWidgets);
    expect(find.text('Sections'), findsWidgets);
    expect(find.text('Questions'), findsWidgets);
    expect(find.text('Choices'), findsWidgets);
    expect(find.text('Conditions'), findsWidgets);
    expect(find.text('Submit'), findsWidgets);
    expect(find.text('Actions'), findsWidgets);
    expect(find.text('Workflow'), findsWidgets);
    expect(find.text('Themes'), findsWidgets);
  });

  testWidgets('Response submission renders effective UI fields', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CurrentUserState>(create: (_) => CurrentUserState()),
          ChangeNotifierProvider<SessionStateNotifier>(
            create: (_) => SessionStateNotifier(authRepository: FakeAuthRepository()),
          ),
          Provider<ProjectsApi>(create: (_) => FakeProjectsApi()),
          Provider<FormsApi>(create: (_) => FakeFormsApi()),
          Provider<SectionsApi>(create: (_) => FakeSectionsApi()),
          Provider<QuestionsApi>(create: (_) => FakeQuestionsApi()),
          Provider<ChoicesApi>(create: (_) => FakeChoicesApi()),
          Provider<ConditionsApi>(create: (_) => FakeConditionsApi()),
          Provider<AdminApi>(create: (_) => FakeAdminApi()),
          Provider<UiTemplatesApi>(create: (_) => FakeUiTemplatesApi()),
          Provider<SystemApi>(create: (_) => FakeSystemApi()),
          Provider<WorkflowsApi>(create: (_) => FakeWorkflowsApi()),
          Provider<ResponsesApi>(create: (_) => FakeResponsesApi()),
        ],
        child: const MaterialApp(
          home: ResponseSubmissionPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Response Submission'), findsWidgets);
    expect(tester.widgetList<DropdownButtonFormField<String>>(find.byType(DropdownButtonFormField<String>)).length, greaterThanOrEqualTo(2));
  });
}
