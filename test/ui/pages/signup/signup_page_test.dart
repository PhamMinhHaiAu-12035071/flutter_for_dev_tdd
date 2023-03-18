import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/ui/pages/signup/signup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

class DomainExceptionSpy extends Mock implements DomainException {}

void main() {
  late SignUpPresenter presenter;
  late StreamController<DomainException?> nameErrorController;
  late StreamController<DomainException?> emailErrorController;
  late StreamController<DomainException?> passwordErrorController;
  late StreamController<DomainException?> passwordConfirmationErrorController;

  setUp(() {
    nameErrorController = StreamController<DomainException?>();
    emailErrorController = StreamController<DomainException?>();
    passwordErrorController = StreamController<DomainException?>();
    passwordConfirmationErrorController = StreamController<DomainException?>();
  });

  void mockStream() {
    when(() => presenter.nameError)
        .thenAnswer((_) => nameErrorController.stream);
    when(() => presenter.emailError)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordError)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.passwordConfirmationError)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = Get.put<SignUpPresenter>(SignUpPresenterSpy());
    mockStream();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    ///Find the name TextFormField
    final nameTextChildren = find.descendant(
      of: find.bySemanticsLabel('Name'),
      matching: find.byType(Text),
    );

    expect(nameTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the children is always the label text');

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

    /// Find the password confirmation TextFormField
    final passwordConfirmationTextChildren = find.descendant(
      of: find.bySemanticsLabel('Password Confirmation'),
      matching: find.byType(Text),
    );

    expect(passwordConfirmationTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the children is always the label text');

    /// Find the login button
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct values', (widgetTester) async {
    await loadPage(widgetTester);

    /// Enter name
    final name = faker.person.name();
    await widgetTester.enterText(find.bySemanticsLabel('Name'), name);

    when(() => presenter.validateName(name)).thenAnswer((_) {
      return;
    });
    verify(() => presenter.validateName(name)).called(1);

    /// Enter email
    final email = faker.internet.email();
    await widgetTester.enterText(find.bySemanticsLabel('Email'), email);

    when(() => presenter.validateEmail(email)).thenAnswer((_) {
      return;
    });
    verify(() => presenter.validateEmail(email)).called(1);

    /// Enter password
    final password = faker.internet.password();
    await widgetTester.enterText(find.bySemanticsLabel('Password'), password);

    when(() => presenter.validatePassword(password)).thenAnswer((_) {
      return;
    });
    verify(() => presenter.validatePassword(password)).called(1);

    /// Enter password confirmation
    final passwordConfirmation = faker.internet.password();
    await widgetTester.enterText(
        find.bySemanticsLabel('Password Confirmation'), passwordConfirmation);

    when(() => presenter.validatePasswordConfirmation(passwordConfirmation))
        .thenAnswer((_) {
      return;
    });
    verify(() => presenter.validatePasswordConfirmation(passwordConfirmation))
        .called(1);
  });
}
