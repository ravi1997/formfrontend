import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/questions/data/questions_api.dart';

class QuestionsRepositoryImpl {
  final QuestionsApi _api;

  QuestionsRepositoryImpl(this._api);

  Future<ApiResult<List<dynamic>>> listQuestions({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) {
    return _api.listQuestions(
      projectUuid: projectUuid,
      formUuid: formUuid,
      sectionUuid: sectionUuid,
    );
  }
}
