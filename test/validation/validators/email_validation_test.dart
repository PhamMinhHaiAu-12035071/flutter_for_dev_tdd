import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/validators/validators.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ValidationExceptionSpy extends Mock implements ValidationException {}

void main() {
  late FieldValidation sut;
  late ValidationException validationException;

  void mockValidationExceptionMessage(String message) {
    when(() => validationException.message).thenReturn(message);
  }

  setUp(() {
    validationException = ValidationExceptionSpy();
    sut = EmailValidation('any_field', validationException);
  });
  test('Should return null if email is empty', () {
    final error = sut.validate('');
    expect(error, null);
  });

  test('Should return null if email is null', () {
    final error = sut.validate(null);
    expect(error, null);
  });
  test('Should return null if email is valid', () {
    final error = sut.validate('phamau1994x@gmail.com');
    expect(error, null);
  });
  test('Should return error if email is invalid', () {
    mockValidationExceptionMessage('Email invalid');
    final error = sut.validate('phamau1994x');

    expect(error, isNotNull);
    expect(error?.message, 'Email invalid');
  });
}
