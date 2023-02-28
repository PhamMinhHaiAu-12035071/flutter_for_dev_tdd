import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/helpers/helpers.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late StreamLoginPresenter sut;
  late String email;
  late String password;

  When mockValidationCall(String? field, String? value) =>
      when(() => validation.validate(
          field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? field, String? value}) =>
      mockValidationCall(field, value).thenReturn(value);

  When mockAuthenticationCall() => when(() => authentication.auth(any()));

  void mockAuthentication({String? field, String? value}) =>
      mockAuthenticationCall()
          .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  void mockAuthenticationError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error);
  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation(field: 'email');
    mockValidation(field: 'password');
    mockAuthentication();
  });
  setUpAll(() {
    registerFallbackValue(const AuthenticationParams(email: '', secret: ''));
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email errors if validation fails', () {
    mockValidation(field: 'email', value: 'error');
    sut.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });
  test('Should emit email null if validation succeeds', () {
    mockValidation(field: 'email');
    sut.emailErrorStream?.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));
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
    sut.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password null if validation succeeds', () {
    sut.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  group('Should emit isFormValid false if email or password is invalid', () {
    test('with email error', () {
      mockValidation(field: 'email', value: 'error');
      sut.emailErrorStream
          ?.listen(expectAsync1((error) => expect(error, 'error')));
      sut.passwordErrorStream
          ?.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          ?.listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('with password error', () {
      mockValidation(field: 'password', value: 'error');
      sut.emailErrorStream
          ?.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordErrorStream
          ?.listen(expectAsync1((error) => expect(error, 'error')));
      sut.isFormValidStream
          ?.listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
    test('with email and password error', () {
      mockValidation(field: 'email', value: 'error');
      mockValidation(field: 'password', value: 'error');
      sut.emailErrorStream
          ?.listen(expectAsync1((error) => expect(error, 'error')));
      sut.passwordErrorStream
          ?.listen(expectAsync1((error) => expect(error, 'error')));
      sut.isFormValidStream
          ?.listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });
  test('Should emit password null if validation succeeds', () {
    sut.emailErrorStream?.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
    sut.validateEmail(email);
    sut.validateEmail(email);
    Future.delayed(Duration.zero).then((_) {
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
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

  test('Should emit correct events on Authentication success', () async {
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    await sut.auth();
    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct events on Authentication on InvalidCredentials',
      () async {
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    mockAuthenticationError(DomainError.invalidCredentials);
    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream?.listen(expectAsync1(
        (error) => expect(error, DomainError.invalidCredentials.description)));
    await sut.auth();
  });

  test('Should emit correct events on Authentication on UnexpectedError',
      () async {
    mockValidation(field: 'email', value: email);
    mockValidation(field: 'password', value: password);
    sut.validateEmail(email);
    sut.validatePassword(password);
    mockAuthenticationError(DomainError.unexpected);
    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream?.listen(expectAsync1(
        (error) => expect(error, DomainError.unexpected.description)));
    await sut.auth();
  });

  test('Should not emit event after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));
    sut.dispose();
    sut.validateEmail(email);
  });
}
