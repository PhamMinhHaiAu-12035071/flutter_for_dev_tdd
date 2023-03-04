import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/helpers/helpers.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/pages/login/login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late Validation validation;
  late Authentication authentication;
  late SaveCurrentAccount saveCurrentAccount;
  late LoginPresenter sut;
  late String email;
  late String password;
  late String token;

  When mockValidationCall(String? field, String? value) =>
      when(() => validation.validate(
          field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? field, String? value}) =>
      mockValidationCall(field, value).thenReturn(value);

  When mockAuthenticationCall() => when(() => authentication.auth(any()));

  void mockAuthentication({String? field, String? value}) =>
      mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  void mockAuthenticationError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error);

  When mockSaveCurrentAccountCall() =>
      when(() => saveCurrentAccount.save(any()));

  void mockSaveCurrentAccountError() =>
      mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  void mockSaveCurrentAccount() =>
      mockSaveCurrentAccountCall().thenAnswer((_) async => Future.value);
  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation(field: 'email');
    mockValidation(field: 'password');
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
    mockValidation(field: 'email', value: 'error');
    sut.emailError.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });
  test('Should emit email null if validation succeeds', () {
    mockValidation(field: 'email');
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
    mockValidation(field: 'password', value: 'error');
    sut.passwordError.listen(expectAsync1((error) => expect(error, 'error')));
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
      mockValidation(field: 'email', value: 'error');
      sut.emailError.listen(expectAsync1((error) => expect(error, 'error')));
      sut.passwordError.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('with password error', () {
      mockValidation(field: 'password', value: 'error');
      sut.emailError.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordError.listen(expectAsync1((error) => expect(error, 'error')));
      sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
    test('with email and password error', () {
      mockValidation(field: 'email', value: 'error');
      mockValidation(field: 'password', value: 'error');
      sut.emailError.listen(expectAsync1((error) => expect(error, 'error')));
      sut.passwordError.listen(expectAsync1((error) => expect(error, 'error')));
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
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();
    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();
    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit correct events on Authentication success', () async* {
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    await sut.auth();
    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct events on Authentication on InvalidCredentials',
      () async* {
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    mockAuthenticationError(DomainError.invalidCredentials);
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    sut.mainError.listen(expectAsync1(
        (error) => expect(error, DomainError.invalidCredentials.description)));
    await sut.auth();
  });

  test('Should emit correct events on Authentication on UnexpectedError',
      () async* {
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    mockAuthenticationError(DomainError.unexpected);
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    sut.mainError.listen(expectAsync1(
        (error) => expect(error, DomainError.unexpected.description)));
    await sut.auth();
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async* {
    mockSaveCurrentAccountError();
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    expectLater(sut.isLoading, emitsInOrder([true, false]));
    sut.mainError.listen(expectAsync1(
        (error) => expect(error, DomainError.unexpected.description)));
    await sut.auth();
  });

  test('Should change page on success', () async {
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.navigateTo.listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.auth();
  });
}
