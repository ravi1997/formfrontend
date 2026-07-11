import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class WorkflowsApi {
  final ApiClient _client;

  WorkflowsApi(this._client);

  Future<ApiResult<Map<String, dynamic>>> submitWorkflow({
    required String projectUuid,
    required String formUuid,
    Map<String, dynamic>? payload,
  }) {
    return _client.post(
      ApiEndpoints.submitFormWorkflow(projectUuid, formUuid),
      data: payload ?? const <String, dynamic>{},
    );
  }

  Future<ApiResult<Map<String, dynamic>>> reviewWorkflow({
    required String projectUuid,
    required String formUuid,
    Map<String, dynamic>? payload,
  }) {
    return _client.post(
      ApiEndpoints.reviewFormWorkflow(projectUuid, formUuid),
      data: payload ?? const <String, dynamic>{},
    );
  }

  Future<ApiResult<Map<String, dynamic>>> approveWorkflow({
    required String projectUuid,
    required String formUuid,
    Map<String, dynamic>? payload,
  }) {
    return _client.post(
      ApiEndpoints.approveFormWorkflow(projectUuid, formUuid),
      data: payload ?? const <String, dynamic>{},
    );
  }
}
