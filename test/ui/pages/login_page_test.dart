import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_page.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool?> isFormValidController;
  late StreamController<bool?> isLoadingController;
  late StreamController<String?> mainErrorController;

  void initStream() {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool?>();
    isLoadingController = StreamController<bool?>();
    mainErrorController = StreamController<String?>();
  }

  void mockStream() {
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
  }

  void closeStream() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  }

  tearDown(() {
    closeStream();
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    initStream();
    mockStream();
    final loginPage = MaterialApp(home: LoginPage(presenter: presenter));
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
    emailErrorController.add('any_error');

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
    emailErrorController.add('');

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
    passwordErrorController.add('any_error');

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
    passwordErrorController.add('');

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
    mainErrorController.add('any_error');
    await widgetTester.pump();

    expect(find.text('any_error'), findsOneWidget);
  });

  testWidgets('Should close streams on dispose', (widgetTester) async {
    await loadPage(widgetTester);
    addTearDown(() {
      verify(() => presenter.dispose()).called(1);
    });
  });
}
