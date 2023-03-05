import 'package:flutter/material.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SplashScreenPresenterSpy extends Mock implements SplashScreenPresenter {}

void main() {
  late SplashScreenPresenter presenter;
  late RxnString navigateTo;

  Future<void> loadPage(widgetTester) async {
    await widgetTester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => SplashPage(
                  presenter: presenter,
                )),
        GetPage(
            name: '/any_route',
            page: () => const Scaffold(body: Text('fake page'))),
      ],
    ));
  }

  When mockLoadCurrentAccount() => when(() => presenter.loadCurrentAccount());

  void mockLoadCurrentAccountSuccess() =>
      mockLoadCurrentAccount().thenAnswer((_) async => {});

  setUp(() {
    navigateTo = RxnString();
    presenter = SplashScreenPresenterSpy();

    when(() => presenter.navigateTo).thenAnswer((_) => navigateTo);
    mockLoadCurrentAccountSuccess();
  });

  testWidgets('Should present spinner on load page', (widgetTester) async {
    await loadPage(widgetTester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call loadCurrentAccount on page load',
      (widgetTester) async {
    await loadPage(widgetTester);
    verify(() => presenter.loadCurrentAccount()).called(1);
  });

  testWidgets('Should load page', (widgetTester) async {
    await loadPage(widgetTester);
    navigateTo.value = '/any_route';
    await widgetTester.pumpAndSettle();
    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (widgetTester) async {
    await loadPage(widgetTester);
    navigateTo.value = '';
    await widgetTester.pump();
    expect(Get.currentRoute, '/');
    expect(find.text('fake page'), findsNothing);

    navigateTo.value = null;
    await widgetTester.pump();
    expect(Get.currentRoute, '/');
    expect(find.text('fake page'), findsNothing);
  });
}
