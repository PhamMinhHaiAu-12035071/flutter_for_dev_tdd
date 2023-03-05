import 'package:flutter_for_dev_tdd/main/builders/builders.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeValidations());
}

List<FieldValidation> makeValidations() => [
      ...ValidationBuilder.field('email').required().build(),
      ...ValidationBuilder.field('password').required().build(),
    ];
