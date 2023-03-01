import 'package:flutter_for_dev_tdd/presentation/protocols/validation.dart';
import 'package:flutter_for_dev_tdd/ui/validation/protocols/protocols.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late FieldValidation validation1;
  late FieldValidation validation2;

  setUp(() {
    validation1 = FieldValidationSpy();
    when(() => validation1.field).thenReturn('any_field');
    when(() => validation1.validate(any())).thenReturn(null);
    validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn('any_field');
    when(() => validation2.validate(any())).thenReturn(null);
  });

  test('Should return null if all validations returns null or empty', () {
    final sut = ValidationComposite([validation1, validation2]);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}
