import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class ProjectsApi {
  final ApiClient _client;

  ProjectsApi(this._client);

  Future<ApiResult<List<dynamic>>> listProjects() {
    return _client.get(ApiEndpoints.projects);
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

  Future<ApiResult<List<dynamic>>> listProjectVersions(String projectUuid) {
    return _client.get(ApiEndpoints.projectVersions(projectUuid));
  }
}
