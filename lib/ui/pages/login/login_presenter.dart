import 'dart:async';

import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';

abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();
  void dispose();

  Stream<DomainException?> get emailError;
  Stream<DomainException?> get passwordError;
  Stream<bool> get isFormValid;
  Stream<bool> get isLoading;
  Stream<DomainException?> get mainError;
  Stream<String?> get navigateTo;
}
