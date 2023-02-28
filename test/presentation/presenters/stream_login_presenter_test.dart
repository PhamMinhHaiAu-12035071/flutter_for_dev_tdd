import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/presentation/presenters/presenters.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late ValidationSpy validation;
  late StreamLoginPresenter sut;
  late String email;
  late String password;

  When mockValidationCall(String? field, String? value) =>
      when(() => validation.validate(
          field: field ?? any(named: 'field'), value: any(named: 'value')));

  void mockValidation({String? field, String? value}) =>
      mockValidationCall(field, value).thenReturn(value);

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
  });
  tearDown(() {
    reset(validation);
  });

  test('Should call Validation with correct email', () {
    mockValidation(field: 'email');
    sut.validateEmail(email);
    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email errors if validation fails', () {
    mockValidation(field: 'email', value: 'error');
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });
  test('Should emit email null if validation succeeds', () {
    mockValidation(field: 'email', value: null);
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    mockValidation(field: 'password');
    sut.validatePassword(password);
    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit password errors if validation fails', () {
    mockValidation(field: 'password', value: 'error');
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password null if validation succeeds', () {
    mockValidation(field: 'password', value: null);
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  group('Should emit isFormValid false if email or password is invalid', () {
    test('with email error', () {
      mockValidation(field: 'email', value: 'error');
      mockValidation(field: 'password', value: null);
      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('with password error', () {
      mockValidation(field: 'email', value: null);
      mockValidation(field: 'password', value: 'error');
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
    test('with email and password error', () {
      mockValidation(field: 'email', value: 'error');
      mockValidation(field: 'password', value: 'error');
      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));
      sut.validateEmail(email);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });
  test('Should emit password null if validation succeeds', () {
    mockValidation(field: 'email');
    mockValidation(field: 'password');
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
    sut.validateEmail(email);
    sut.validateEmail(email);
    Future.delayed(Duration.zero).then((_) {
      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });
}
