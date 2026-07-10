import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formfrontend/app/app.dart';
import 'package:formfrontend/core/storage/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FakeSecureTokenStorage extends SecureTokenStorage {
  final Map<String, String> _data = {};

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? sessionUuid,
  }) async {
    _data['access_token'] = accessToken;
    _data['refresh_token'] = refreshToken;
    if (sessionUuid != null) _data['session_uuid'] = sessionUuid;
  }

  @override
  Future<String?> getAccessToken() async => _data['access_token'];

  @override
  Future<String?> getRefreshToken() async => _data['refresh_token'];

  @override
  Future<String?> getSessionUuid() async => _data['session_uuid'];

  @override
  Future<void> clearAll() async => _data.clear();
}

void main() {
  testWidgets('Smoke test for A.D.I.Y.O.G.I App', (WidgetTester tester) async {
    // Set screen size for test environment to initialize responsive sizer properly
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await dotenv.load(fileName: 'assets/.env');
    final fakeStorage = FakeSecureTokenStorage();

    // Build our app with injected fake storage
    await tester.pumpWidget(App(tokenStorage: fakeStorage));
    
    // Pump frames to complete async auth check
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify that the login page brand name is rendered.
    expect(find.text('A.D.I.Y.O.G.I'), findsWidgets);
  });
}
