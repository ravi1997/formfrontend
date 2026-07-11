import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class ConditionsApi {
  final ApiClient _client;

  ConditionsApi(this._client);

  Future<ApiResult<Map<String, dynamic>>> metadata() {
    return _client.get(ApiEndpoints.conditionsMetadata);
  }

  Future<ApiResult<Map<String, dynamic>>> operatorsMetadata() {
    return _client.get(ApiEndpoints.conditionsOperatorsMetadata);
  }

  Future<ApiResult<Map<String, dynamic>>> testCondition(Map<String, dynamic> payload) {
    return _client.post(ApiEndpoints.testCondition, data: payload);
  }

  Future<ApiResult<Map<String, dynamic>>> testBatchConditions(Map<String, dynamic> payload) {
    return _client.post(ApiEndpoints.testBatchConditions, data: payload);
  }

  Future<ApiResult<Map<String, dynamic>>> monitoringGraph() {
    return _client.get(ApiEndpoints.monitoringGraph);
  }

  Future<ApiResult<Map<String, dynamic>>> presets() {
    return _client.get(ApiEndpoints.presets);
  }
}
