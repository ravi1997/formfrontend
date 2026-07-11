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
}
