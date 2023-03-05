import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:get/get.dart';

abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();

  Rxn<DomainException> get emailError;
  Rxn<DomainException> get passwordError;
  RxBool get isFormValid;
  RxBool get isLoading;
  Rxn<DomainException> get mainError;
  RxnString get navigateTo;
}
