import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/api/api_response_parsers.dart';

class SearchApi {
  final ApiClient _client;

  SearchApi(this._client);

  Future<ApiResult<List<dynamic>>> search({
    required String query,
    int limit = 20,
  }) async {
    final result = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.search,
      queryParameters: {'q': query, 'limit': limit},
    );
    return result.when(
      success: (data) => ApiResult.success(ApiResponseParsers.parseList(data)),
      failure: (error) => ApiResult.failure(error),
    );
  }
}
