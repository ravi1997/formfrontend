import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class ChoicesApi {
  final ApiClient _client;

  ChoicesApi(this._client);

  Future<ApiResult<List<dynamic>>> listChoices({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
  }) async {
    final result = await _client.get<Map<String, dynamic>>(ApiEndpoints.choices(projectUuid, formUuid, sectionUuid, questionUuid));
    return result.when(
      success: (data) => ApiResult.success(data['items'] as List<dynamic>? ?? []),
      failure: (error) => ApiResult.failure(error),
    );
  }

  Future<ApiResult<Map<String, dynamic>>> createChoice({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
    required Map<String, dynamic> payload,
  }) {
    return _client.post(
      ApiEndpoints.choices(projectUuid, formUuid, sectionUuid, questionUuid),
      data: payload,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getChoice({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
    required String choiceUuid,
  }) {
    return _client.get(
      ApiEndpoints.choiceDetail(projectUuid, formUuid, sectionUuid, questionUuid, choiceUuid),
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateChoice({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
    required String choiceUuid,
    required Map<String, dynamic> payload,
  }) {
    return _client.patch(
      ApiEndpoints.choiceDetail(projectUuid, formUuid, sectionUuid, questionUuid, choiceUuid),
      data: payload,
    );
  }

  Future<ApiResult<void>> deleteChoice({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required String questionUuid,
    required String choiceUuid,
  }) {
    return _client.delete(
      ApiEndpoints.choiceDetail(projectUuid, formUuid, sectionUuid, questionUuid, choiceUuid),
    );
  }
}
