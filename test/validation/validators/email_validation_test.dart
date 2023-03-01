import 'package:flutter_for_dev_tdd/ui/validation/protocols/protocols.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String? value) {
    final regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value!);
    return isValid ? null : 'Email invalid';
  }
}

void main() {
  late FieldValidation sut;
  setUp(() {
    sut = EmailValidation('any_field');
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
