import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_page.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

class DomainExceptionSpy extends Mock implements DomainException {}

void main() {
  late LoginPresenter presenter;
  late StreamController<DomainException?> emailErrorController;
  late StreamController<DomainException?> passwordErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<DomainException> mainErrorController;
  late StreamController<String> navigateToController;
  late DomainException domainException;

  setUp(() {
    emailErrorController = StreamController<DomainException?>();
    passwordErrorController = StreamController<DomainException?>();
    isFormValidController = StreamController<bool>();
    isFormValidController.add(false);
    isLoadingController = StreamController<bool>();
    isLoadingController.add(false);
    mainErrorController = StreamController<DomainException>();
    navigateToController = StreamController<String>();
    domainException = DomainExceptionSpy();
  });
  void mockStream() {
    when(() => presenter.emailError)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordError)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.isFormValid)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoading)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.mainError)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => presenter.navigateTo)
        .thenAnswer((_) => navigateToController.stream);
  }

  void mockDomainExceptionMessage(String message) {
    when(() => domainException.message).thenReturn(message);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = Get.put<LoginPresenter>(LoginPresenterSpy());
    mockStream();
    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter: presenter)),
        GetPage(
            name: '/any_route',
            page: () => const Scaffold(body: Text('fake page'))),
      ],
    );
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
  });

  testWidgets('Should present error if email is invalid', (widgetTester) async {
    await loadPage(widgetTester);
    mockDomainExceptionMessage('any_error');

    emailErrorController.add(domainException);

    await widgetTester.pump();

    expect(find.text('any_error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid',
      (widgetTester) async {
    await loadPage(widgetTester);

    emailErrorController.add(null);

    await widgetTester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present no error if email is valid',
      (widgetTester) async {
    await loadPage(widgetTester);
    emailErrorController.add(null);
    await widgetTester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if password is invalid',
      (widgetTester) async {
    await loadPage(widgetTester);
    mockDomainExceptionMessage('any_error');
    passwordErrorController.add(domainException);
    await widgetTester.pump();

    expect(find.text('any_error'), findsOneWidget);
  });

  testWidgets('Should present no error if password is valid',
      (widgetTester) async {
    await loadPage(widgetTester);
    passwordErrorController.add(null);
    await widgetTester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Password'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present no error if password is valid',
      (widgetTester) async {
    await loadPage(widgetTester);
    passwordErrorController.add(null);
    await widgetTester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Password'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should enable button if form is valid', (widgetTester) async {
    await loadPage(widgetTester);
    isFormValidController.add(true);
    await widgetTester.pump();
    final button =
        widgetTester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid', (widgetTester) async {
    await loadPage(widgetTester);
    isFormValidController.add(false);
    await widgetTester.pump();
    final button =
        widgetTester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('Should call authentication on form submit',
      (widgetTester) async {
    await loadPage(widgetTester);
    isFormValidController.add(true);
    await widgetTester.pumpAndSettle();
    await widgetTester.ensureVisible(find.byType(ElevatedButton));
    expect(find.byType(ElevatedButton), findsOneWidget);
    final button =
        widgetTester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
    await widgetTester.pump();
    when(presenter.auth).thenAnswer((_) async {});
    await widgetTester.tap(find.byType(ElevatedButton));
    verify(() => presenter.auth()).called(1);
  });

  testWidgets('Should present loading when form is submit',
      (widgetTester) async {
    await loadPage(widgetTester);
    isLoadingController.add(true);
    await widgetTester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hidden loading', (widgetTester) async {
    await loadPage(widgetTester);
    isLoadingController.add(true);
    await widgetTester.pump();
    isLoadingController.add(false);
    await widgetTester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if authentication is failed',
      (widgetTester) async {
    await loadPage(widgetTester);
    mockDomainExceptionMessage('any_error');
    mainErrorController.add(domainException);
    await widgetTester.pump();

    expect(find.text('any_error'), findsOneWidget);
  });

  testWidgets('Should change page', (widgetTester) async {
    await loadPage(widgetTester);
    navigateToController.add('/any_route');
    await widgetTester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });
}
