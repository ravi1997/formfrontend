import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class AdminApi {
  final ApiClient _client;

  AdminApi(this._client);

  Future<ApiResult<Map<String, dynamic>>> configHealth() {
    return _client.get(ApiEndpoints.configHealth);
  }

  Future<ApiResult<List<dynamic>>> auditLogs() {
    return _client.get(ApiEndpoints.auditLogs);
  }

  Future<ApiResult<List<dynamic>>> rateLimitLogs() {
    return _client.get(ApiEndpoints.rateLimitLogs);
  }

  Future<ApiResult<Map<String, dynamic>>> rateLimitStatus() {
    return _client.get(ApiEndpoints.rateLimitStatus);
  }

  Future<ApiResult<Map<String, dynamic>>> listOrganizations({String? status}) {
    return _client.get(
      '/organizations',
      queryParameters: status != null ? {'status': status} : null,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> createOrganization(Map<String, dynamic> data) {
    return _client.post('/organizations', data: data);
  }

  Future<ApiResult<Map<String, dynamic>>> updateOrganization(String uuid, Map<String, dynamic> data) {
    return _client.patch('/organizations/$uuid', data: data);
  }

  Future<ApiResult<Map<String, dynamic>>> deleteOrganization(String uuid) {
    return _client.delete('/organizations/$uuid');
  }
}
