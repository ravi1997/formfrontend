// ignore_for_file: prefer_initializing_formals
import 'package:dio/dio.dart';
import 'package:formfrontend/core/api/api_endpoints.dart';
import 'package:formfrontend/core/config/app_config.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';

class ApiInterceptors extends Interceptor {
  final SecureTokenStorage _tokenStorage;
  final Dio _refreshDio; // Dedicated Dio instance to perform token refreshes without recursive interception

  ApiInterceptors({
    required SecureTokenStorage tokenStorage,
    Dio? refreshDio,
  })  : _tokenStorage = tokenStorage,
        _refreshDio = refreshDio ?? Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: AppConfig.connectTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
          ),
        );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if error is 401 Unauthorized and not already requesting a refresh/login/register path
    final isUnauthorized = err.response?.statusCode == 401;
    final requestPath = err.requestOptions.path;
    final isAuthRoute = requestPath.contains(ApiEndpoints.login) ||
        requestPath.contains(ApiEndpoints.register) ||
        requestPath.contains(ApiEndpoints.refresh);

    if (isUnauthorized && !isAuthRoute) {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Perform refreshing logic
          final response = await _refreshDio.post(
            ApiEndpoints.refresh,
            options: Options(
              headers: {'Authorization': 'Bearer $refreshToken'},
            ),
          );

          if (response.statusCode == 200 && response.data != null) {
            final data = response.data as Map<String, dynamic>;
            final newAccessToken = data['access_token'] as String;
            final newRefreshToken = data['refresh_token'] as String;
            final newSessionUuid = data['session_uuid'] as String?;

            // Store new tokens
            await _tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
              sessionUuid: newSessionUuid,
            );

            // Retry the original failed request with the new access token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final dio = Dio(); // Clean temporary client for the retry
            final retryResponse = await dio.request(
              '${options.baseUrl}${options.path}',
              data: options.data,
              queryParameters: options.queryParameters,
              options: Options(
                method: options.method,
                headers: options.headers,
                contentType: options.contentType,
              ),
            );

            return handler.resolve(retryResponse);
          }
        } catch (_) {
          // Refresh failed, clear storage to trigger log out / auth state update
          await _tokenStorage.clearAll();
        }
      }
    }

    super.onError(err, handler);
  }
}
