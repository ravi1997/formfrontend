import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/api/api_response_parsers.dart';

class AdminApi {
  final ApiClient _client;

  AdminApi(this._client);

  Future<ApiResult<Map<String, dynamic>>> configHealth() {
    return _client.get(ApiEndpoints.configHealth);
  }

  Future<ApiResult<List<dynamic>>> auditLogs() {
    return _client.get<Map<String, dynamic>>(ApiEndpoints.auditLogs).then(
      (result) => result.when(
        success: (data) => ApiResult.success(ApiResponseParsers.parseList(data)),
        failure: (error) => ApiResult.failure(error),
      ),
    );
  }

  Future<ApiResult<List<dynamic>>> rateLimitLogs() {
    return _client.get<Map<String, dynamic>>(ApiEndpoints.rateLimitLogs).then(
      (result) => result.when(
        success: (data) => ApiResult.success(ApiResponseParsers.parseList(data)),
        failure: (error) => ApiResult.failure(error),
      ),
    );
  }

  Future<ApiResult<Map<String, dynamic>>> rateLimitStatus() {
    return _client.get(ApiEndpoints.rateLimitStatus);
  }

  Future<ApiResult<List<dynamic>>> listOrganizations({String? status}) {
    return _client.get<Map<String, dynamic>>(
      ApiEndpoints.organizations,
      queryParameters: status != null ? {'status': status} : null,
    ).then(
      (result) => result.when(
        success: (data) => ApiResult.success(ApiResponseParsers.parseList(data)),
        failure: (error) => ApiResult.failure(error),
      ),
    );
  }

  Future<ApiResult<Map<String, dynamic>>> createOrganization(Map<String, dynamic> data) {
    return _client.post(ApiEndpoints.organizations, data: data);
  }

  Future<ApiResult<Map<String, dynamic>>> updateOrganization(String uuid, Map<String, dynamic> data) {
    return _client.patch(ApiEndpoints.organizationDetail(uuid), data: data);
  }

  Future<ApiResult<Map<String, dynamic>>> deleteOrganization(String uuid) {
    return _client.delete(ApiEndpoints.organizationDetail(uuid));
  }
}
