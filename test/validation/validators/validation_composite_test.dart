import 'package:flutter_for_dev_tdd/presentation/protocols/validation.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/validators/validators.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

class ValidationExceptionSpy extends Mock implements ValidationException {}

void main() {
  late FieldValidation validation1;
  late FieldValidation validation2;
  late FieldValidation validation3;
  late Validation sut;
  late ValidationException validationException;

  void mockValidation1(ValidationException? error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  void mockValidation2(ValidationException? error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  void mockValidation3(ValidationException? error) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  void mockValidationExceptionMessage(String msg) {
    when(() => validationException.message).thenReturn(msg);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    validationException = ValidationExceptionSpy();
    when(() => validation1.field).thenReturn('other_field');
    mockValidation1(null);
    validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn('other_field');
    mockValidation2(null);
    validation3 = FieldValidationSpy();
    when(() => validation3.field).thenReturn('any_field');
    mockValidation3(null);
    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });
  test('Should return the first error found', () {
    mockValidationExceptionMessage('error_1');
    mockValidation1(validationException);

    mockValidationExceptionMessage('error_2');
    mockValidation2(validationException);

    mockValidationExceptionMessage('error_3');
    mockValidation3(validationException);
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, isNotNull);
    expect(error?.message, 'error_3');
  });
}
