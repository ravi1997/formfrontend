import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formfrontend/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Gateway screen exposes the four primary entry points', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.pumpAndSettle();

    expect(find.text('Gateway'), findsOneWidget);
    expect(find.text('Workspace home'), findsWidgets);
    expect(find.text('Search'), findsWidgets);
    expect(find.text('Navigation shell'), findsWidgets);
    expect(find.text('Integrations hub'), findsWidgets);
    expect(find.text('Operations panel'), findsWidgets);
  });
}
