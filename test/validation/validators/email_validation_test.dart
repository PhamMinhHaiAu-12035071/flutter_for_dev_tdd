import 'package:flutter_for_dev_tdd/ui/validation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  late FieldValidation sut;
  setUp(() {
    sut = const EmailValidation('any_field');
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
    final error = sut.validate('phamau1994x');
    expect(error, 'Email invalid');
  });
}
