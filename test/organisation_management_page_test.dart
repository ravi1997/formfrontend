import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:formfrontend/core/api/api_client.dart';
import 'package:formfrontend/core/api/api_result.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formfrontend/features/admin/data/admin_api.dart';
import 'package:formfrontend/features/admin/presentation/organisation_management_page.dart';

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

class _FakeAdminApi extends AdminApi {
  _FakeAdminApi() : super(_apiClient);

  @override
  Future<ApiResult<List<dynamic>>> listOrganizations({String? status}) async {
    return ApiResult.success([
      {'uuid': 'org-1', 'name': 'Org One', 'status': 'active', 'admins': ['a1']},
      {'uuid': 'org-2', 'name': 'Org Two', 'status': 'inactive', 'admins': []},
    ]);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> createOrganization(Map<String, dynamic> data) async {
    return ApiResult.success(data);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateOrganization(String uuid, Map<String, dynamic> data) async {
    return ApiResult.success({'uuid': uuid, ...data});
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> deleteOrganization(String uuid) async {
    return ApiResult.success({'uuid': uuid});
  }
}

void main() {
  testWidgets('Organisation management page shows summary and organisations', (tester) async {
    await dotenv.load(fileName: 'assets/.env');
    final api = _FakeAdminApi();
    await tester.pumpWidget(
      Provider<AdminApi>.value(
        value: api,
        child: const MaterialApp(home: OrganisationManagementPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Organisation Management'), findsOneWidget);
    expect(find.text('Organisation Summary'), findsOneWidget);
    expect(find.text('Loaded organisations: 2'), findsOneWidget);
    expect(find.text('Active organisations: 2'), findsOneWidget);
    expect(find.text('Filtered organisations: 2'), findsOneWidget);
    expect(find.text('Org One'), findsOneWidget);
    expect(find.text('Org Two'), findsOneWidget);
  });
}
