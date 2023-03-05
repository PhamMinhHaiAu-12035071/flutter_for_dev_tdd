import 'package:flutter_for_dev_tdd/presentation/protocols/validation.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/validators/validators.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late FieldValidation validation1;
  late FieldValidation validation2;
  late FieldValidation validation3;
  late Validation sut;

  void mockValidation1(String? error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  void mockValidation2(String? error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  void mockValidation3(String? error) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
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
    mockValidation1('error_1');
    mockValidation2('error_2');
    mockValidation3('error_3');
    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, 'error_3');
  });
}
