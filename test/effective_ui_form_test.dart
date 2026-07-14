import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formfrontend/features/forms/presentation/widgets/effective_ui_form.dart';

void main() {
  testWidgets('Effective UI form renders payload card when fields are absent', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EffectiveUiForm(
            ui: {'message': 'fallback'},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Effective UI payload'), findsOneWidget);
    expect(find.textContaining('fallback'), findsWidgets);
  });
}

