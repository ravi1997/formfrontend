import 'package:dio/dio.dart';
import 'package:formfrontend/core/models/error_payload.dart';

class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final ErrorPayload? payload;

  const ApiError({
    required this.message,
    this.statusCode,
    this.payload,
  });

  factory ApiError.fromDioException(DioException error) {
    String message = 'Network connection issue. Please check your network.';
    int? statusCode = error.response?.statusCode;
    ErrorPayload? payload;

    if (error.response?.data != null && error.response?.data is Map<String, dynamic>) {
      try {
        payload = ErrorPayload.fromJson(error.response!.data as Map<String, dynamic>);
        message = payload.message;
      } catch (_) {
        // Fallback if structure is slightly different
        final data = error.response!.data as Map<String, dynamic>;
        message = data['message'] as String? ?? data['error'] as String? ?? 'Server error';
      }
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Request timed out. Please try again.';
          break;
        case DioExceptionType.badResponse:
          message = 'Server returned an invalid response (${error.response?.statusCode}).';
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled.';
          break;
        case DioExceptionType.connectionError:
          message = 'Unable to connect to the server. Ensure the backend is running.';
          break;
        default:
          message = error.message ?? 'An unexpected network error occurred.';
      }
    }

    return ApiError(
      message: message,
      statusCode: statusCode,
      payload: payload,
    );
  }

  @override
  String toString() => message;
}
