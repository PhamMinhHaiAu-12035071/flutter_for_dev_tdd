import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/pages/pages.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

class ValidationExceptionSpy extends Mock implements ValidationException {}

class HttpExceptionSpy extends Mock implements HttpException {}

void main() {
  late Validation validation;
  late AddAccount addAccount;
  late SaveCurrentAccount saveCurrentAccount;
  late SignUpPresenter sut;
  late ValidationException validationException;
  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;
  late String token;
  late HttpException httpException;

  When mockValidationCall(String? field, String? value) =>
      when(() => validation.validate(
          field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation(
          {String? field, String? value, ValidationException? error}) =>
      mockValidationCall(field, value).thenReturn(error);

  void mockValidationExceptionMessage(String message) {
    when(() => validationException.message).thenReturn(message);
  }

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

  When mockAddAccountCall() => when(() => addAccount.add(any()));
  void mockAddAccount() =>
      mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));

  When mockSaveCurrentAccountCall() =>
      when(() => saveCurrentAccount.save(any()));

  void mockSaveCurrentAccount() =>
      mockSaveCurrentAccountCall().thenAnswer((_) async => Future.value);

  void mockHttpExceptionMessage(String message) {
    when(() => httpException.message).thenReturn(message);
  }

  void mockAddAccountException() {
    mockAddAccountCall().thenThrow(httpException);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    httpException = HttpExceptionSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    name = faker.internet.userName();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();
    validationException = ValidationExceptionSpy();
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    mockValidation(field: 'passwordConfirmation', value: passwordConfirmation);
    mockValidation(field: 'name', value: name);
    mockAddAccount();
    mockSaveCurrentAccount();
  });

  setUpAll(() {
    registerFallbackValue(const AddAccountParams(
      name: '',
      email: '',
      password: '',
      passwordConfirmation: '',
    ));
    registerFallbackValue(const AccountEntity(''));
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

  test('Should emit isFormValid true if all fields are valid', () async {
    sut.nameError.listen(expectAsync1((error) => expect(error, null)));
    sut.emailError.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordConfirmationError
        .listen(expectAsync1((error) => expect(error, null)));
    expectLater(sut.isFormValid, emitsInOrder([false, true]));
    executeValidate();
  });

  test('Should call AddAccount with correct values', () async {
    executeValidate();
    await sut.signUp();
    verify(() => addAccount.add(AddAccountParams(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation))).called(1);
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    executeValidate();
    await sut.signUp();
    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should call AddAccount and SaveAccount with correct values', () async {
    executeValidate();
    await sut.signUp();
    verify(() => addAccount.add(AddAccountParams(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation))).called(1);
    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });
  test('Should emit correct events on AddAccount success', () async {
    executeValidate();
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    await sut.signUp();
  });

  test('Should emit correct events on AddAccount on EmailInUseException',
      () async {
    executeValidate();
    mockHttpExceptionMessage(R.strings.emailInUseError);
    mockAddAccountException();
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    sut.mainError.listen(expectAsync1(
        (error) => expect(error?.message, R.strings.emailInUseError)));
    await sut.signUp();
  });

  test('Should emit correct events on AddAccount on UnexpectedException',
      () async {
    executeValidate();
    mockHttpExceptionMessage(R.strings.httpUnexpected);
    mockAddAccountException();
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    sut.mainError.listen(expectAsync1(
        (error) => expect(error?.message, R.strings.httpUnexpected)));
    await sut.signUp();
  });
}
