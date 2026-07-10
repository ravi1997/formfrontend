// ignore_for_file: prefer_initializing_formals
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/auth/auth_repository.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/auth/data/auth_api.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final SecureTokenStorage _storage;

  AuthRepositoryImpl({
    required AuthApi api,
    required SecureTokenStorage storage,
  })  : _api = api,
        _storage = storage;

  @override
  Future<ApiResult<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    final result = await _api.login(email: email, password: password);
    return result.when(
      success: (data) async {
        final authResponse = AuthResponse.fromJson(data);
        await _storage.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          sessionUuid: authResponse.sessionUuid,
        );
        return ApiResult.success(authResponse);
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    String? designation,
    String? phone,
    String? deviceName,
  }) async {
    final result = await _api.register(
      name: name,
      email: email,
      password: password,
      designation: designation,
      phone: phone,
      deviceName: deviceName,
    );
    return result.when(
      success: (data) async {
        final authResponse = AuthResponse.fromJson(data);
        await _storage.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          sessionUuid: authResponse.sessionUuid,
        );
        return ApiResult.success(authResponse);
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> logout() async {
    final result = await _api.logout();
    await _storage.clearAll();
    return result;
  }

  @override
  Future<ApiResult<UserProfile>> getMe() async {
    final result = await _api.getMe();
    return result.when(
      success: (data) => ApiResult.success(UserProfile.fromJson(data)),
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<List<SessionInfo>>> getSessions() async {
    final result = await _api.getSessions();
    return result.when(
      success: (data) {
        final list = data.map((e) => SessionInfo.fromJson(e as Map<String, dynamic>)).toList();
        return ApiResult.success(list);
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  @override
  Future<ApiResult<void>> revokeSession(String sessionUuid) async {
    return _api.revokeSession(sessionUuid);
  }

  @override
  Future<ApiResult<void>> logoutAll({bool keepCurrent = true}) async {
    final result = await _api.logoutAll(keepCurrent: keepCurrent);
    if (!keepCurrent) {
      await _storage.clearAll();
    }
    return result;
  }
}
