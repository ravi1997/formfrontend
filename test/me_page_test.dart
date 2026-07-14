import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:formfrontend/features/auth/data/auth_api.dart';
import 'package:formfrontend/features/auth/presentation/me_page.dart';

class _InMemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write({
    required String key,
    String? value,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    return _values[key];
  }

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
  }) async {
    _values.remove(key);
  }
}

final _apiClient = ApiClient(tokenStorage: SecureTokenStorage(storage: _InMemorySecureStorage()));

class _FakeAuthApi extends AuthApi {
  _FakeAuthApi() : super(_apiClient);

  @override
  Future<ApiResult<Map<String, dynamic>>> getMe() async {
    return ApiResult.success({
      'uuid': 'u1',
      'name': 'User One',
      'email': 'user@example.com',
      'status': 'active',
      'roles': ['admin', 'editor'],
      'is_super_admin': true,
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Me page shows structured profile summary', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    await tester.pumpWidget(
      Provider<AuthApi>(
        create: (_) => _FakeAuthApi(),
        child: const MaterialApp(home: MePage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Me'), findsOneWidget);
    expect(find.text('Profile Summary'), findsOneWidget);
    expect(find.text('UUID: u1'), findsOneWidget);
    expect(find.text('Name: User One'), findsOneWidget);
    expect(find.text('Email: user@example.com'), findsOneWidget);
    expect(find.text('Status: active'), findsOneWidget);
    expect(find.text('Roles: 2'), findsOneWidget);
    expect(find.text('Role list: admin, editor'), findsOneWidget);
    expect(find.text('Super admin: true'), findsOneWidget);
  });
}
