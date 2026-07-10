import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthResponse>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    String? designation,
    String? phone,
    String? deviceName,
  });

  Future<ApiResult<void>> logout();

  Future<ApiResult<UserProfile>> getMe();

  Future<ApiResult<List<SessionInfo>>> getSessions();

  Future<ApiResult<void>> revokeSession(String sessionUuid);

  Future<ApiResult<void>> logoutAll({bool keepCurrent = true});
}
