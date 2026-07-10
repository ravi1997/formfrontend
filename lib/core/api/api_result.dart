import 'package:formfrontend/core/errors/api_error.dart';

abstract class ApiResult<T> {
  const ApiResult();

  factory ApiResult.success(T data) = SuccessResult<T>;
  factory ApiResult.failure(ApiError error) = FailureResult<T>;

  bool get isSuccess => this is SuccessResult<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => this is SuccessResult<T> ? (this as SuccessResult<T>).data : null;
  ApiError? get errorOrNull => this is FailureResult<T> ? (this as FailureResult<T>).error : null;

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiError error) failure,
  }) {
    if (this is SuccessResult<T>) {
      return success((this as SuccessResult<T>).data);
    } else {
      return failure((this as FailureResult<T>).error);
    }
  }
}

class SuccessResult<T> extends ApiResult<T> {
  final T data;
  const SuccessResult(this.data);
}

class FailureResult<T> extends ApiResult<T> {
  final ApiError error;
  const FailureResult(this.error);
}
