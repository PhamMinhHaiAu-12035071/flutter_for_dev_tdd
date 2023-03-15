import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

class ValidationExceptionSpy extends Mock implements ValidationException {}

class HttpExceptionSpy extends Mock implements HttpException {}

class IOExceptionSpy extends Mock implements DomainException {}

void main() {
  late Validation validation;
  late Authentication authentication;
  late SaveCurrentAccount saveCurrentAccount;
  late LoginPresenter sut;
  late String email;
  late String password;
  late String token;
  late ValidationException validationException;
  late HttpException httpException;
  late DomainException ioException;

  When mockValidationCall(String? field, String? value) =>
      when(() => validation.validate(
          field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation(
          {String? field, String? value, ValidationException? error}) =>
      mockValidationCall(field, value).thenReturn(error);

  When mockAuthenticationCall() => when(() => authentication.auth(any()));

  void mockAuthentication({String? field, String? value}) =>
      mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));

  void mockAuthenticationError() {
    mockAuthenticationCall().thenThrow(httpException);
  }

  When mockSaveCurrentAccountCall() =>
      when(() => saveCurrentAccount.save(any()));

  void mockSaveCurrentAccount() =>
      mockSaveCurrentAccountCall().thenAnswer((_) async => Future.value);

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(ioException);
  }

  void mockValidationExceptionMessage(String message) {
    when(() => validationException.message).thenReturn(message);
  }

  void mockHttpExceptionMessage(String message) {
    when(() => httpException.message).thenReturn(message);
  }

  void mockIOExceptionMessage(String message) {
    when(() => ioException.message).thenReturn(message);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount);
    validationException = ValidationExceptionSpy();
    httpException = HttpExceptionSpy();
    ioException = IOExceptionSpy();
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    mockAuthentication();
    mockSaveCurrentAccount();
  });
  setUpAll(() {
    registerFallbackValue(const AuthenticationParams(email: '', secret: ''));
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

  group('Should emit isFormValid false if email or password is invalid', () {
    test('with email error', () {
      mockValidationExceptionMessage('error');
      mockValidation(
          field: 'email', value: 'error', error: validationException);
      sut.emailError
          .listen(expectAsync1((error) => expect(error?.message, 'error')));
      sut.passwordError.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('with password error', () {
      mockValidationExceptionMessage('error');
      mockValidation(
          field: 'password', value: 'error', error: validationException);
      sut.emailError.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordError
          .listen(expectAsync1((error) => expect(error?.message, 'error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
    test('with email and password error', () {
      mockValidationExceptionMessage('error');
      mockValidation(
          field: 'email', value: 'error', error: validationException);
      mockValidation(
          field: 'password', value: 'error', error: validationException);
      sut.emailError
          .listen(expectAsync1((error) => expect(error?.message, 'error')));
      sut.passwordError
          .listen(expectAsync1((error) => expect(error?.message, 'error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });
  test('Should emit password null if validation succeeds', () async* {
    sut.emailError.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));
    expectLater(sut.isFormValid, emitsInOrder([false, true]));
    sut.validateEmail(email);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();
    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();
    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit correct events on Authentication success', () async* {
    sut.validateEmail(email);
    sut.validatePassword(password);
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    await sut.auth();
    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test(
      'Should emit correct events on Authentication on HttpInvalidCredentialsException',
      () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    mockHttpExceptionMessage(R.strings.httpInvalidCredentials);
    mockAuthenticationError();
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    sut.mainError.listen(expectAsync1((error) {
      expect(error?.message, R.strings.httpInvalidCredentials);
    }));
    await sut.auth();
  });

  test(
      'Should emit correct events on Authentication on HttpUnexpectedException',
      () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    mockHttpExceptionMessage(R.strings.httpUnexpected);
    mockAuthenticationError();
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    sut.mainError.listen(expectAsync1(
        (error) => expect(error?.message, R.strings.httpUnexpected)));
    await sut.auth();
  });

  test(
      'Should emit correct events on SaveCurrentAccount on FileSystemException',
      () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    mockIOExceptionMessage(R.strings.fileSystemException);
    mockSaveCurrentAccountError();
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    sut.mainError.listen(expectAsync1(
        (error) => expect(error?.message, R.strings.fileSystemException)));
    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.navigateTo.listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.auth();
  });
}
