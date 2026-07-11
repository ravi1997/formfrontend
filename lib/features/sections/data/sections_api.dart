import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class SectionsApi {
  final ApiClient _client;

  SectionsApi(this._client);

  Future<ApiResult<List<dynamic>>> listSections({
    required String projectUuid,
    required String formUuid,
  }) {
    return _client.get(ApiEndpoints.sections(projectUuid, formUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> createSection({
    required String projectUuid,
    required String formUuid,
    required Map<String, dynamic> payload,
  }) {
    return _client.post(ApiEndpoints.sections(projectUuid, formUuid), data: payload);
  }

  Future<ApiResult<Map<String, dynamic>>> getSection({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) {
    return _client.get(ApiEndpoints.sectionDetail(projectUuid, formUuid, sectionUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> updateSection({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
    required Map<String, dynamic> payload,
  }) {
    return _client.patch(ApiEndpoints.sectionDetail(projectUuid, formUuid, sectionUuid), data: payload);
  }

  Future<ApiResult<void>> deleteSection({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) {
    return _client.delete(ApiEndpoints.sectionDetail(projectUuid, formUuid, sectionUuid));
  }

  Future<ApiResult<List<dynamic>>> listSectionVersions({
    required String projectUuid,
    required String formUuid,
    required String sectionUuid,
  }) {
    return _client.get(ApiEndpoints.sectionVersions(projectUuid, formUuid, sectionUuid));
  }
}
