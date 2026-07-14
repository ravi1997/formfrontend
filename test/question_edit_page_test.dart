import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';
import 'package:formfrontend/features/questions/presentation/question_edit_page.dart';

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

class _FakeQuestionsApi extends QuestionsApi {
  _FakeQuestionsApi() : super(_apiClient);

  Map<String, dynamic>? savedPayload;

  @override
  Future<ApiResult<Map<String, dynamic>>> getQuestion({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) async {
    return ApiResult.success({
      'uuid': questionUuid,
      'label': 'Original Question',
      'type': 'text',
      'placeholder': 'Enter value',
      'description': 'Question description',
      'status': 'active',
      'choices': [],
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateQuestion({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
    required Map<String, dynamic> payload,
  }) async {
    savedPayload = payload;
    return ApiResult.success({
      'uuid': questionUuid,
      ...payload,
    });
  }
}

void main() {
  testWidgets('Question edit shows backend fields and saves payload', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    final api = _FakeQuestionsApi();

    await tester.pumpWidget(
      Provider<QuestionsApi>.value(
        value: api,
        child: const MaterialApp(
          home: QuestionEditPage(
            projectUuid: 'p1',
            formUuid: 'f1',
            sectionUuid: 's1',
            questionUuid: 'q1',
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Question Edit'), findsOneWidget);
    expect(find.text('UUID: q1'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Updated Question');
    await tester.enterText(find.byType(TextField).at(1), 'number');
    await tester.enterText(find.byType(TextField).at(2), 'Placeholder text');
    await tester.enterText(find.byType(TextField).at(3), 'Desc');
    await tester.enterText(find.byType(TextField).at(4), 'Help');
    await tester.enterText(find.byType(TextField).at(5), 'Tip');
    await tester.scrollUntilVisible(
      find.text('Save Question'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save Question'));
    await tester.pump();

    expect(api.savedPayload, isNotNull);
    expect(api.savedPayload!['label'], 'Updated Question');
    expect(api.savedPayload!['type'], 'number');
    expect(api.savedPayload!['placeholder'], 'Placeholder text');
    expect(api.savedPayload!['help_text'], 'Help');
  });
}
