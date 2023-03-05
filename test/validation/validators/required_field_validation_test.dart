import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/validators/validators.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ValidationExceptionSpy extends Mock implements ValidationException {}

void main() {
  late ValidationException validationException;
  late FieldValidation sut;

  void mockValidationExceptionMessage(String message) {
    when(() => validationException.message).thenReturn(message);
  }

  setUp(() {
    validationException = ValidationExceptionSpy();
    sut = RequiredFieldValidation('any_field', validationException);
  });
  test('Should return null if value is not empty', () {
    final error = sut.validate('any_value');

    expect(error, null);
  });

  test('Should return error if value is empty', () {
    mockValidationExceptionMessage('Field is not empty');
    final error = sut.validate('');

    expect(error, isNotNull);
    expect(error?.message, 'Field is not empty');
  });

  test('Should return error if value is null', () {
    mockValidationExceptionMessage('Field is not empty');
    final error = sut.validate(null);

    expect(error, isNotNull);
    expect(error?.message, 'Field is not empty');
  });
}
