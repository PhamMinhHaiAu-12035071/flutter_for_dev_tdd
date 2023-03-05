import 'dart:async';

import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/helpers/helpers.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _password;
  final _emailError = Rxn<DomainException>();
  final _passwordError = Rxn<DomainException>();
  final _mainError = Rxn<DomainException>();
  final _isFormValid = RxBool(false);
  final _isLoading = RxBool(false);
  final _navigateTo = RxnString();

  @override
  Rxn<DomainException> get emailError => _emailError;
  @override
  Rxn<DomainException> get passwordError => _passwordError;
  @override
  RxBool get isFormValid => _isFormValid;
  @override
  RxBool get isLoading => _isLoading;
  @override
  Rxn<DomainException> get mainError => _mainError;
  @override
  RxnString get navigateTo => _navigateTo;

  GetxLoginPresenter(
      {required this.validation,
      required this.authentication,
      required this.saveCurrentAccount});

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  @override
  Future<void> auth() async {
    _isLoading.value = true;
    try {
      final account = await authentication
          .auth(AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(AccountEntity(account.token));
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _mainError.value = CommonValidationException(error.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
