import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shmr/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Create task from navigating to new page',
    (tester) async {
      const textToType = 'Awesome integration test title from new page';
      await app.main();
      await tester.pumpAndSettle();

      await Future<void>.delayed(const Duration(seconds: 1));
      final createButton = find.byType(FloatingActionButton);
      await tester.tap(createButton);

      await Future<void>.delayed(const Duration(seconds: 1));
      final textField = find.byType(TextField);
      await tester.tap(textField);
      await tester.enterText(textField, textToType);

      await Future<void>.delayed(const Duration(seconds: 1));
      final saveButton = find.byType(TextButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text(textToType), findsWidgets);
    },
  );
}
