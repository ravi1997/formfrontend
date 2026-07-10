import 'package:dio/dio.dart';
import 'package:formfrontend/core/api/api_interceptors.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/config/app_config.dart';
import 'package:formfrontend/core/errors/api_error.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required SecureTokenStorage tokenStorage,
    Dio? dio,
  }) : _dio = dio ?? Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: AppConfig.connectTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
            contentType: 'application/json',
          ),
        ) {
    _dio.interceptors.add(
      ApiInterceptors(tokenStorage: tokenStorage),
    );
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<ApiResult<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<ApiResult<T>> _request<T>(Future<Response<dynamic>> Function() call) async {
    try {
      final response = await call();
      return ApiResult.success(response.data as T);
    } on DioException catch (e) {
      return ApiResult.failure(ApiError.fromDioException(e));
    } catch (e) {
      return ApiResult.failure(
        ApiError(
          message: e.toString(),
        ),
      );
    }
  }
}
