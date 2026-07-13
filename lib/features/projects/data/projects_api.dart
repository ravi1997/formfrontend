import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class ProjectsApi {
  final ApiClient _client;

  ProjectsApi(this._client);

  Future<ApiResult<List<dynamic>>> listProjects() async {
    final result = await _client.get<Map<String, dynamic>>(ApiEndpoints.projects);
    return result.when(
      success: (data) => ApiResult.success(data['items'] as List<dynamic>? ?? []),
      failure: (error) => ApiResult.failure(error),
    );
  }

  Future<ApiResult<Map<String, dynamic>>> createProject(Map<String, dynamic> payload) {
    return _client.post(ApiEndpoints.projects, data: payload);
  }

  Future<ApiResult<Map<String, dynamic>>> getProject(String projectUuid) {
    return _client.get(ApiEndpoints.projectDetail(projectUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> updateProject(
    String projectUuid,
    Map<String, dynamic> payload,
  ) {
    return _client.patch(ApiEndpoints.projectDetail(projectUuid), data: payload);
  }

  Future<ApiResult<void>> deleteProject(String projectUuid) {
    return _client.delete(ApiEndpoints.projectDetail(projectUuid));
  }

  Future<ApiResult<List<dynamic>>> listProjectVersions(String projectUuid) async {
    final result = await _client.get<Map<String, dynamic>>(ApiEndpoints.projectVersions(projectUuid));
    return result.when(
      success: (data) => ApiResult.success(data['items'] as List<dynamic>? ?? []),
      failure: (error) => ApiResult.failure(error),
    );
  }
}
