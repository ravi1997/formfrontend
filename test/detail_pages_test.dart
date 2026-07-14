import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/forms/presentation/form_detail_page.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/projects/presentation/project_detail_page.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';
import 'package:formfrontend/features/questions/presentation/question_detail_page.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';
import 'package:formfrontend/features/sections/presentation/section_detail_page.dart';

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
  Future<ApiResult<Map<String, dynamic>>> getProject(String projectUuid) async {
    return ApiResult.success({
      'uuid': projectUuid,
      'name': 'Project $projectUuid',
      'status': 'active',
      'owner': 'Owner',
      'versions': [
        {'uuid': 'v1'},
      ],
    });
  }
}

class _FakeFormsApi extends FormsApi {
  _FakeFormsApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> getForm(String projectUuid, String formUuid) async {
    return ApiResult.success({
      'uuid': formUuid,
      'name': 'Form $formUuid',
      'status': 'draft',
      'created_by': 'Creator',
      'versions': [
        {'uuid': 'v1'},
        {'uuid': 'v2'},
      ],
    });
  }
}

class _FakeSectionsApi extends SectionsApi {
  _FakeSectionsApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> getSection({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) async {
    return ApiResult.success({
      'uuid': sectionUuid,
      'name': 'Section $sectionUuid',
      'status': 'review',
      'position': 3,
      'questions': [
        {'uuid': 'q1'},
        {'uuid': 'q2'},
      ],
    });
  }
}

class _FakeQuestionsApi extends QuestionsApi {
  _FakeQuestionsApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> getQuestion({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) async {
    return ApiResult.success({
      'uuid': questionUuid,
      'label': 'Question $questionUuid',
      'type': 'text',
      'required': true,
      'choices': [
        {'uuid': 'c1'},
      ],
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Project detail shows summary card and debug payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<ProjectsApi>(
        create: (_) => _FakeProjectsApi(),
        child: const MaterialApp(home: ProjectDetailPage(projectUuid: 'p1')),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Project p1'), findsOneWidget);
    expect(find.text('Status: active'), findsOneWidget);
    expect(find.text('Owner: Owner'), findsOneWidget);
    expect(find.text('Versions: 1'), findsOneWidget);
    expect(find.textContaining('Project p1'), findsWidgets);
  });

  testWidgets('Form detail shows summary card, payload, and effective UI action', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<FormsApi>(
        create: (_) => _FakeFormsApi(),
        child: const MaterialApp(home: FormDetailPage(projectUuid: 'p1', formUuid: 'f1')),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Form f1'), findsOneWidget);
    expect(find.text('Status: draft'), findsOneWidget);
    expect(find.text('Owner: Creator'), findsOneWidget);
    expect(find.text('Versions: 2'), findsOneWidget);
    expect(find.text('Open Effective UI'), findsOneWidget);
  });

  testWidgets('Section detail shows summary card and payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<SectionsApi>(
        create: (_) => _FakeSectionsApi(),
        child: const MaterialApp(
          home: SectionDetailPage(
            projectUuid: 'p1',
            formUuid: 'f1',
            sectionUuid: 's1',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Section s1'), findsOneWidget);
    expect(find.text('Status: review'), findsOneWidget);
    expect(find.text('Position: 3'), findsOneWidget);
    expect(find.text('Questions: 2'), findsOneWidget);
  });

  testWidgets('Question detail shows summary card and payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<QuestionsApi>(
        create: (_) => _FakeQuestionsApi(),
        child: const MaterialApp(
          home: QuestionDetailPage(
            projectUuid: 'p1',
            formUuid: 'f1',
            sectionUuid: 's1',
            questionUuid: 'q1',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Question q1'), findsOneWidget);
    expect(find.text('Type: text'), findsOneWidget);
    expect(find.text('Required: true'), findsOneWidget);
    expect(find.text('Choices: 1'), findsOneWidget);
  });
}

