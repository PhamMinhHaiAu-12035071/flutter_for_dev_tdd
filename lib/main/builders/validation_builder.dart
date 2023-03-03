import 'package:flutter_for_dev_tdd/ui/validation/validators/validators.dart';

import '../../ui/validation/protocols/field_validation.dart';

class ValidationBuilder {
  static late ValidationBuilder _instance;
  String fieldName;
  List<FieldValidation> validations = [];

  ValidationBuilder._({required this.fieldName});

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._(fieldName: fieldName);
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(fieldName));
    return this;
  }

  List<FieldValidation> build() {
    return validations;
  }
}
