import 'package:flutter_for_dev_tdd/ui/validation/protocols/protocols.dart';

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
