import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class ResponsesApi {
  final ApiClient _client;

  ResponsesApi(this._client);

  Future<ApiResult<Map<String, dynamic>>> listActionExecutions({
    required String projectUuid,
    required String formUuid,
    required String responseUuid,
  }) {
    return _client.get(ApiEndpoints.actionExecutions(projectUuid, formUuid, responseUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> submitResponse({
    required String projectUuid,
    required String formUuid,
    required Map<String, dynamic> payload,
  }) {
    return _client.post(
      ApiEndpoints.publicResponses(projectUuid, formUuid),
      data: payload,
    );
  }
}
