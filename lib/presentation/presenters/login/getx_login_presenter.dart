import 'dart:async';

import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
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
  Stream<DomainException?> get emailError => _emailError.stream;
  @override
  Stream<DomainException?> get passwordError => _passwordError.stream;
  @override
  Stream<bool> get isFormValid => _isFormValid.stream;
  @override
  Stream<bool> get isLoading => _isLoading.stream;
  @override
  Stream<DomainException?> get mainError => _mainError.stream;
  @override
  Stream<String?> get navigateTo => _navigateTo.stream;

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
      /// credentials login
      final account = await authentication
          .auth(AuthenticationParams(email: _email!, secret: _password!));

      /// save account in cache
      await saveCurrentAccount.save(AccountEntity(account.token));
      _navigateTo.value = '/surveys';
    } on DomainException catch (error) {
      _mainError.value = error;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailError.close();
    _passwordError.close();
    _mainError.close();
    _isFormValid.close();
    _isLoading.close();
    _navigateTo.close();
  }
}
