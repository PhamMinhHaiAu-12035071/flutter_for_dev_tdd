import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:get/get.dart';

abstract class SignUpPresenter {
  Rxn<DomainException> get nameError;
  Rxn<DomainException> get emailError;
  Rxn<DomainException> get passwordError;
  Rxn<DomainException> get passwordConfirmationError;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String passwordConfirmation);
}
