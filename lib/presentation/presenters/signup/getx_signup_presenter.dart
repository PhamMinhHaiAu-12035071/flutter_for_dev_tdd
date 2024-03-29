import 'package:flutter_for_dev_tdd/domain/exceptions/domain_exception.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:get/get.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  final _nameError = Rxn<DomainException>();
  final _emailError = Rxn<DomainException>();
  final _passwordError = Rxn<DomainException>();
  final _passwordConfirmationError = Rxn<DomainException>();
  final _isFormValid = RxBool(false);
  final _isLoading = RxBool(false);
  final _mainError = Rxn<DomainException>();

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  @override
  Stream<DomainException?> get emailError => _emailError.stream;

  @override
  Stream<bool> get isFormValid => _isFormValid.stream;

  @override
  Stream<bool> get isLoading => _isLoading.stream;

  @override
  Stream<DomainException?> get mainError => _mainError.stream;

  @override
  Stream<DomainException?> get nameError => _nameError.stream;

  @override
  // TODO: implement navigateTo
  Stream<String?> get navigateTo => throw UnimplementedError();

  @override
  Stream<DomainException?> get passwordConfirmationError =>
      _passwordConfirmationError.stream;

  @override
  Stream<DomainException?> get passwordError => _passwordError.stream;

  @override
  Future<void> signUp() async {
    if (_isFormValid.value == false) return;

    _isLoading.value = true;
    try {
      final account = await addAccount.add(
        AddAccountParams(
          name: _name!,
          email: _email!,
          password: _password!,
          passwordConfirmation: _passwordConfirmation!,
        ),
      );

      await saveCurrentAccount.save(account);
    } on DomainException catch (error) {
      _mainError.value = error;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = validation.validate(field: 'name', value: name);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = validation.validate(
        field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _email != null &&
        _name != null &&
        _password != null &&
        _passwordConfirmation != null &&
        _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null;
  }
}
