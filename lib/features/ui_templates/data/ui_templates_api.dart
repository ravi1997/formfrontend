import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class UiTemplatesApi {
  final ApiClient _client;

  UiTemplatesApi(this._client);

  Future<ApiResult<List<dynamic>>> listThemeTemplates() {
    return _client.get(ApiEndpoints.themeTemplates);
  }

  Future<ApiResult<List<dynamic>>> listLayoutTemplates() {
    return _client.get(ApiEndpoints.layoutTemplates);
  }

  Future<ApiResult<Map<String, dynamic>>> getThemeTemplate(String templateUuid) {
    return _client.get('${ApiEndpoints.themeTemplates}/$templateUuid');
  }

  Future<ApiResult<Map<String, dynamic>>> getLayoutTemplate(String templateUuid) {
    return _client.get('${ApiEndpoints.layoutTemplates}/$templateUuid');
  }
}
