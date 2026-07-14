import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';
import 'package:formfrontend/features/choices/presentation/choice_edit_page.dart';
import 'package:formfrontend/features/forms/data/forms_api.dart';
import 'package:formfrontend/features/forms/presentation/form_versions_page.dart';
import 'package:formfrontend/features/projects/data/projects_api.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';
import 'package:formfrontend/features/questions/presentation/question_versions_page.dart';
import 'package:formfrontend/features/sections/data/sections_api.dart';
import 'package:formfrontend/features/sections/presentation/section_versions_page.dart';

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

  @override
  Future<ApiResult<List<dynamic>>> listFormVersions(String projectUuid, String formUuid) async {
    return ApiResult.success([
      {'version': 'v2', 'label': 'Draft'},
      {'version': 'v1', 'label': 'Published'},
    ]);
  }
}

class _FakeSectionsApi extends SectionsApi {
  _FakeSectionsApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listSectionVersions({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) async {
    return ApiResult.success([
      {'version': 'v2', 'label': 'Draft'},
    ]);
  }
}

class _FakeQuestionsApi extends QuestionsApi {
  _FakeQuestionsApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listQuestionVersions({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) async {
    return ApiResult.success([
      {'version': 'v3', 'label': 'Reviewed'},
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
      {'uuid': 'c1', 'name': 'Choice 1', 'value': 'a'},
      {'uuid': 'c2', 'name': 'Choice 2', 'value': 'b'},
    ]);
  }
}

class _FakeProjectsApi extends ProjectsApi {
  _FakeProjectsApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listProjects() async {
    return ApiResult.success([
      {'uuid': 'p1', 'name': 'Project 1'},
    ]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Form versions page shows version summary cards', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<FormsApi>(
        create: (_) => _FakeFormsApi(),
        child: const MaterialApp(
          home: FormVersionsPage(projectUuid: 'p1', formUuid: 'f1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Form Versions'), findsWidgets);
    expect(find.text('Version count: 2'), findsOneWidget);
    expect(find.text('Version 1'), findsOneWidget);
    expect(find.text('Version 2'), findsOneWidget);
  });

  testWidgets('Section versions page shows version summary cards', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<SectionsApi>(
        create: (_) => _FakeSectionsApi(),
        child: const MaterialApp(
          home: SectionVersionsPage(projectUuid: 'p1', formUuid: 'f1', sectionUuid: 's1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Section Versions'), findsWidgets);
    expect(find.text('Version count: 1'), findsOneWidget);
    expect(find.text('Version 1'), findsOneWidget);
  });

  testWidgets('Question versions page shows version summary cards', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<QuestionsApi>(
        create: (_) => _FakeQuestionsApi(),
        child: const MaterialApp(
          home: QuestionVersionsPage(
            projectUuid: 'p1',
            formUuid: 'f1',
            sectionUuid: 's1',
            questionUuid: 'q1',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Question Versions'), findsWidgets);
    expect(find.text('Version count: 1'), findsOneWidget);
    expect(find.text('Version 1'), findsOneWidget);
  });

  testWidgets('Choice edit page shows choice summary cards', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProjectsApi>(create: (_) => _FakeProjectsApi()),
          Provider<ChoicesApi>(create: (_) => _FakeChoicesApi()),
        ],
        child: const MaterialApp(
          home: ChoiceEditPage(
            projectUuid: 'p1',
            formUuid: 'f1',
            sectionUuid: 's1',
            questionUuid: 'q1',
            choiceUuid: 'c1',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Choice Edit'), findsOneWidget);
    expect(find.text('Choice Editor'), findsOneWidget);
    expect(find.text('Choice count: 2'), findsOneWidget);
    expect(find.text('Choice 1'), findsOneWidget);
    expect(find.text('Choice 2'), findsOneWidget);
  });
}
