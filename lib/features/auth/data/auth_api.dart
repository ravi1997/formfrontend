import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class AuthApi {
  final ApiClient _client;

  AuthApi(this._client);

  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) {
    return _client.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<ApiResult<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    String? designation,
    String? phone,
    String? deviceName,
  }) {
    return _client.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'designation':? designation,
        'phone':? phone,
        'device_name':? deviceName,
      },
    );
  }

  Future<ApiResult<void>> logout() {
    return _client.post(ApiEndpoints.logout);
  }

  Future<ApiResult<Map<String, dynamic>>> getMe() {
    return _client.get(ApiEndpoints.me);
  }

  Future<ApiResult<List<dynamic>>> getSessions() {
    return _client.get(ApiEndpoints.sessions);
  }

  Future<ApiResult<void>> revokeSession(String sessionUuid) {
    return _client.post(
      ApiEndpoints.revokeSession,
      data: {'session_uuid': sessionUuid},
    );
  }

  Future<ApiResult<void>> logoutAll({required bool keepCurrent}) {
    return _client.post(
      ApiEndpoints.logoutAll,
      data: {'keep_current': keepCurrent},
    );
  }
}
