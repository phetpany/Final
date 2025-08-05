import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getapi/admin/states/add_group.dart';
import 'package:getapi/admin/unity/app_controller.dart';
import 'package:get/get.dart';

void main() {
  group('AddGroup Widget', () {
    testWidgets('renders AddGroup and displays Add Group button', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: AddGroup(),
        ),
      );
      expect(find.text('Add Group'), findsOneWidget);
    });

    testWidgets('shows dialog when Add Group button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: AddGroup(),
        ),
      );
      await tester.tap(find.text('Add Group'));
      await tester.pumpAndSettle();
      expect(find.text('Add Group'), findsWidgets); // Button and dialog title
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('shows validation error when saving with empty name', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: AddGroup(),
        ),
      );
      await tester.tap(find.text('Add Group'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Please Fill Name Group'), findsOneWidget);
    });
  });
}
