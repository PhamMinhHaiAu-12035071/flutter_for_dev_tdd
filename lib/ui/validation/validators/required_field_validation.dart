import 'package:flutter_for_dev_tdd/ui/validation/protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    return value?.isEmpty == false ? null : 'Field is not empty';
  }
}
