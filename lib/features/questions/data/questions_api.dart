import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class QuestionsApi {
  final ApiClient _client;

  QuestionsApi(this._client);

  Future<ApiResult<List<dynamic>>> listQuestions({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) {
    return _client.get(ApiEndpoints.questions(projectUuid, formUuid, sectionUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> createQuestion({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required Map<String, dynamic> payload,
  }) {
    return _client.post(ApiEndpoints.questions(projectUuid, formUuid, sectionUuid), data: payload);
  }

  Future<ApiResult<Map<String, dynamic>>> getQuestion({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) {
    return _client.get(ApiEndpoints.questionDetail(projectUuid, formUuid, sectionUuid, questionUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> updateQuestion({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
    required Map<String, dynamic> payload,
  }) {
    return _client.patch(
      ApiEndpoints.questionDetail(projectUuid, formUuid, sectionUuid, questionUuid),
      data: payload,
    );
  }

  Future<ApiResult<void>> deleteQuestion({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) {
    return _client.delete(ApiEndpoints.questionDetail(projectUuid, formUuid, sectionUuid, questionUuid));
  }

  Future<ApiResult<List<dynamic>>> listQuestionVersions({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) {
    return _client.get(ApiEndpoints.questionVersions(projectUuid, formUuid, sectionUuid, questionUuid));
  }
}
