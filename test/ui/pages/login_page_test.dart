import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    const loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    /// Find the email TextFormField
    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no errors, since one of the children is always the label text',
    );

    /// Find the password TextFormField
    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Password'),
      matching: find.byType(Text),
    );

    expect(passwordTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the children is always the label text');

    /// Find the login button
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct values', (widgetTester) async {
    await loadPage(widgetTester);

    /// Enter email
    final email = faker.internet.email();
    await widgetTester.enterText(find.bySemanticsLabel('Email'), email);
  });
}
