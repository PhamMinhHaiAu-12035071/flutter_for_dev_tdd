import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String? validate(String? value);
}

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    return value?.isEmpty == false ? null : 'Field is not empty';
  }
}

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
