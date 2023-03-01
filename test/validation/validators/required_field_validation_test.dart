import 'package:flutter_for_dev_tdd/ui/validation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  late FieldValidation sut;
  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });
  test('Should return null if value is not empty', () {
    final error = sut.validate('any_value');

    expect(error, null);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate('');

    expect(error, 'Field is not empty');
  });

  test('Should return error if value is null', () {
    final error = sut.validate(null);

    expect(error, 'Field is not empty');
  });
}
