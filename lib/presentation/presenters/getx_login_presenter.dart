import 'dart:async';

import 'package:flutter_for_dev_tdd/domain/helpers/helpers.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  String? _email;
  String? _password;
  final _emailError = RxnString();
  final _passwordError = RxnString();
  final _mainError = RxnString();
  final _isFormValid = RxBool(false);
  final _isLoading = RxBool(false);
  @override
  Stream<String?> get emailErrorStream => _emailError.stream;
  @override
  Stream<String?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  @override
  Stream<String?> get mainErrorStream => _mainError.stream;

  GetxLoginPresenter({required this.validation, required this.authentication});

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
      await authentication
          .auth(AuthenticationParams(email: _email!, secret: _password!));
    } on DomainError catch (error) {
      _mainError.value = error.description;
    } finally {
      _isLoading.value = false;
    }
  }
}
