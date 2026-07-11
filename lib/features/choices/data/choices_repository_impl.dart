import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/choices/data/choices_api.dart';

class ChoicesRepositoryImpl {
  final ChoicesApi _api;

  ChoicesRepositoryImpl(this._api);

  Future<ApiResult<List<dynamic>>> listChoices({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) {
    return _api.listChoices(
      projectUuid: projectUuid,
      formUuid: formUuid,
      sectionUuid: sectionUuid,
      questionUuid: questionUuid,
    );
  }
}
