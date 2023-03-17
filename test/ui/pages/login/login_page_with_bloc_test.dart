import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';

class LoginPresenterSpy extends MockCubit<LoginState>
    implements CubitLoginPresenter {}

void main() {
  late LoginPresenter presenter;

  // void mockStream() {
  //   when(() => presenter.emailError).thenAnswer((_) => emailError.stream);
  //   when(() => presenter.passwordError).thenAnswer((_) => passwordError.stream);
  //   when(() => presenter.isFormValid).thenAnswer((_) => isFormValid.stream);
  //   when(() => presenter.isLoading).thenAnswer((_) => isLoading.stream);
  //   when(() => presenter.mainError).thenAnswer((_) => mainError.stream);
  //   when(() => presenter.navigateTo).thenAnswer((_) => navigateTo.stream);
  // }

  // Future<void> loadPage(WidgetTester tester) async {
  //   mockStream();
  //   final loginPage = GetMaterialApp(
  //     initialRoute: '/login',
  //     getPages: [
  //       GetPage(name: '/login', page: () => LoginPage(presenter: presenter)),
  //       GetPage(
  //           name: '/any_route',
  //           page: () => const Scaffold(body: Text('fake page'))),
  //     ],
  //   );
  //   await tester.pumpWidget(loginPage);
  // }
}
