import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/auth/auth_repository.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/state/session_state.dart';
import 'package:formfrontend/features/admin/presentation/admin_user_sessions_page.dart';
import 'package:formfrontend/features/auth/data/auth_models.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<ApiResult<AuthResponse>> login({required String email, required String password}) async =>
      ApiResult.success(const AuthResponse(accessToken: 'a', refreshToken: 'r'));

  @override
  Future<ApiResult<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    String? designation,
    String? phone,
    String? deviceName,
  }) async =>
      ApiResult.success(const AuthResponse(accessToken: 'a', refreshToken: 'r'));

  @override
  Future<ApiResult<void>> logout() async => ApiResult.success(null);

  @override
  Future<ApiResult<UserProfile>> getMe() async => ApiResult.success(
        const UserProfile(uuid: 'u', email: 'u@example.com', name: 'User', roles: []),
      );

  @override
  Future<ApiResult<List<SessionInfo>>> getSessions() async => ApiResult.success([
        const SessionInfo(
          uuid: 's1',
          deviceName: 'Laptop',
          lastActiveAt: '2026-07-13T10:00:00Z',
          isCurrent: true,
        ),
        const SessionInfo(
          uuid: 's2',
          deviceName: 'Phone',
          lastActiveAt: '2026-07-13T09:00:00Z',
          isCurrent: false,
        ),
      ]);

  @override
  Future<ApiResult<void>> revokeSession(String sessionUuid) async => ApiResult.success(null);

  @override
  Future<ApiResult<void>> logoutAll({bool keepCurrent = true}) async => ApiResult.success(null);
}

void main() {
  testWidgets('Admin user sessions page shows summary and rows', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SessionStateNotifier(authRepository: _FakeAuthRepository()),
        child: const MaterialApp(
          home: AdminUserSessionsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('User Sessions'), findsOneWidget);
    expect(find.text('Session summary'), findsOneWidget);
    expect(find.text('Current session: 1'), findsOneWidget);
    expect(find.text('Remote sessions: 1'), findsOneWidget);
    expect(find.text('Laptop'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Current'), findsOneWidget);
    expect(find.text('Revoke'), findsOneWidget);
  });
}
