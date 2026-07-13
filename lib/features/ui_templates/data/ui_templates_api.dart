import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';

class UiTemplatesApi {
  final ApiClient _client;

  UiTemplatesApi(this._client);

  Future<ApiResult<List<dynamic>>> listThemeTemplates() async {
    final result = await _client.get<Map<String, dynamic>>(ApiEndpoints.themeTemplates);
    return result.when(
      success: (data) => ApiResult.success(data['items'] as List<dynamic>? ?? []),
      failure: (error) => ApiResult.failure(error),
    );
  }

  Future<ApiResult<List<dynamic>>> listLayoutTemplates() async {
    final result = await _client.get<Map<String, dynamic>>(ApiEndpoints.layoutTemplates);
    return result.when(
      success: (data) => ApiResult.success(data['items'] as List<dynamic>? ?? []),
      failure: (error) => ApiResult.failure(error),
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getThemeTemplate(String templateUuid) {
    return _client.get('${ApiEndpoints.themeTemplates}/$templateUuid');
  }

  Future<ApiResult<Map<String, dynamic>>> getLayoutTemplate(String templateUuid) {
    return _client.get('${ApiEndpoints.layoutTemplates}/$templateUuid');
  }
}
