import 'package:get/get.dart';

abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();

  RxnString get emailError;
  RxnString get passwordError;
  RxBool get isFormValid;
  RxBool get isLoading;
  RxnString get mainError;
}
