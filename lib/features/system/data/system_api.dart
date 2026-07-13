import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class SystemApi {
  final ApiClient _client;

  SystemApi(this._client);

  Future<ApiResult<Map<String, dynamic>>> health() {
    return _client.get(ApiEndpoints.health);
  }

  Future<ApiResult<Map<String, dynamic>>> readiness() {
    return _client.get(ApiEndpoints.readiness);
  }

  Future<ApiResult<Map<String, dynamic>>> metrics() {
    return _client.get(ApiEndpoints.metrics);
  }

  Future<ApiResult<Map<String, dynamic>>> schemaEcho({String? uuid}) {
    return _client.post(
      ApiEndpoints.echoForm,
      data: {
        'uuid': uuid ?? '00000000-0000-0000-0000-000000000000',
      },
    );
  }
}
