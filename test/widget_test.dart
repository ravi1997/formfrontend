import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formfrontend/app/app.dart';

void main() {
  testWidgets('Smoke test for A.D.I.Y.O.G.I App', (WidgetTester tester) async {
    // Set screen size for test environment to initialize responsive sizer properly
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify that the brand name is rendered.
    expect(find.text('A.D.I.Y.O.G.I'), findsWidgets);
  });
}
