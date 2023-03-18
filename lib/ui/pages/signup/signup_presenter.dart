import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';

abstract class SignUpPresenter {
  Stream<DomainException?> get nameError;
  Stream<DomainException?> get emailError;
  Stream<DomainException?> get passwordError;
  Stream<DomainException?> get passwordConfirmationError;
  Stream<DomainException?> get mainError;
  Stream<bool> get isFormValid;
  Stream<bool> get isLoading;

  void validateName(String name);
  void validateEmail(String email);
  void validatePassword(String password);
  void validatePasswordConfirmation(String passwordConfirmation);
  Future<void> signUp();
  void dispose();
}
