import 'package:flutter_for_dev_tdd/main/factories/pages/login/login_validation_factory.dart';
import 'package:flutter_for_dev_tdd/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeValidations();
    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ]);
  });
}
