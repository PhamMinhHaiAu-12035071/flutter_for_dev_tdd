import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/ui/validation/validators/validators.dart';

import '../../../../ui/validation/protocols/field_validation.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeValidations());
}

List<FieldValidation> makeValidations() => [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ];
