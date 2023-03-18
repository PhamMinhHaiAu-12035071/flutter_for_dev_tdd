import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class AddAccountSpy extends Mock implements AddAccount {}

class ValidationExceptionSpy extends Mock implements ValidationException {}

void main() {
  late Validation validation;
  late Authentication authentication;
  late AddAccount addAccount;
  late SignUpPresenter sut;
  late ValidationException validationException;
  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;

  When mockValidationCall(String? field, String? value) =>
      when(() => validation.validate(
          field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation(
          {String? field, String? value, ValidationException? error}) =>
      mockValidationCall(field, value).thenReturn(error);

  void mockValidationExceptionMessage(String message) {
    when(() => validationException.message).thenReturn(message);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    addAccount = AddAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      authentication: authentication,
      addAccount: addAccount,
    );
    name = faker.internet.userName();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    validationException = ValidationExceptionSpy();
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    mockValidation(field: 'passwordConfirmation', value: passwordConfirmation);
    mockValidation(field: 'name', value: name);
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email errors if validation fails', () {
    mockValidationExceptionMessage('any_error');
    mockValidation(field: 'email', value: email, error: validationException);
    sut.emailError
        .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit email null if validation succeeds', () {
    sut.emailError.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);
    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit password errors if validation fails', () {
    mockValidationExceptionMessage('any_error');
    mockValidation(
        field: 'password', value: 'error', error: validationException);
    sut.passwordError
        .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password null if validation succeeds', () {
    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Validation with correct name', () {
    sut.validateName(name);
    verify(() => validation.validate(field: 'name', value: name)).called(1);
  });

  test('Should emit name errors if validation fails', () {
    mockValidationExceptionMessage('any_error');
    mockValidation(field: 'name', value: 'error', error: validationException);
    sut.nameError
        .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit name null if validation succeeds', () {
    sut.nameError.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password confirmation', () {
    sut.validatePasswordConfirmation(passwordConfirmation);
    verify(() => validation.validate(
        field: 'passwordConfirmation', value: passwordConfirmation)).called(1);
  });

  test('Should emit password confirmation errors if validation fails', () {
    mockValidationExceptionMessage('any_error');
    mockValidation(
        field: 'passwordConfirmation',
        value: 'error',
        error: validationException);
    sut.passwordConfirmationError
        .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit password confirmation null if validation succeeds', () {
    sut.passwordConfirmationError
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  group('Should emit isFormValid false if any field is invalid', () {
    void executeValidate() {
      sut.validateName(name);
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    }

    test('with email error', () async {
      mockValidationExceptionMessage('any_error');
      mockValidation(field: 'email', value: email, error: validationException);
      sut.emailError
          .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      executeValidate();
    });

    test('with name error', () async {
      mockValidationExceptionMessage('any_error');
      mockValidation(field: 'name', value: name, error: validationException);
      sut.nameError
          .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      executeValidate();
    });
    test('with password error', () async {
      mockValidationExceptionMessage('any_error');
      mockValidation(
          field: 'password', value: password, error: validationException);
      sut.passwordError
          .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      executeValidate();
    });

    test('with password confirmation error', () async {
      mockValidationExceptionMessage('any_error');
      mockValidation(
          field: 'passwordConfirmation',
          value: passwordConfirmation,
          error: validationException);
      sut.passwordConfirmationError
          .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      executeValidate();
    });
    test('with name and email error', () async {
      mockValidationExceptionMessage('any_error');
      mockValidation(field: 'name', value: name, error: validationException);
      mockValidation(field: 'email', value: email, error: validationException);
      sut.nameError
          .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
      sut.emailError
          .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      executeValidate();
    });
    test('with name and password error', () async {
      mockValidationExceptionMessage('any_error');
      mockValidation(field: 'name', value: name, error: validationException);
      mockValidation(
          field: 'password', value: password, error: validationException);
      sut.nameError
          .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
      sut.passwordError
          .listen(expectAsync1((error) => expect(error?.message, 'any_error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      executeValidate();
    });

    /// TODO: write continue testcase missing
  });
}
