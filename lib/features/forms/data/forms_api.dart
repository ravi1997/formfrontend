import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class FormsApi {
  final ApiClient _client;

  FormsApi(this._client);

  Future<ApiResult<List<dynamic>>> listForms(String projectUuid) {
    return _client.get(ApiEndpoints.forms(projectUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> createForm(
    String projectUuid,
    Map<String, dynamic> payload,
  ) {
    return _client.post(ApiEndpoints.forms(projectUuid), data: payload);
  }

  Future<ApiResult<Map<String, dynamic>>> getForm(
    String projectUuid,
    String formUuid,
  ) {
    return _client.get(ApiEndpoints.formDetail(projectUuid, formUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> updateForm(
    String projectUuid,
    String formUuid,
    Map<String, dynamic> payload,
  ) {
    return _client.patch(ApiEndpoints.formDetail(projectUuid, formUuid), data: payload);
  }

  Future<ApiResult<void>> deleteForm(
    String projectUuid,
    String formUuid,
  ) {
    return _client.delete(ApiEndpoints.formDetail(projectUuid, formUuid));
  }

  Future<ApiResult<List<dynamic>>> listFormVersions(
    String projectUuid,
    String formUuid,
  ) {
    return _client.get(ApiEndpoints.formVersions(projectUuid, formUuid));
  }

  Future<ApiResult<Map<String, dynamic>>> getEffectiveUi(
    String projectUuid,
    String formUuid,
  ) {
    return _client.get(ApiEndpoints.effectiveUi(projectUuid, formUuid));
  }
}
