import 'package:equatable/equatable.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const EmailValidation(this.field);

  @override
  String? validate(String? value) {
    final regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value!);
    return isValid ? null : 'Email invalid';
  }

  @override
  List<Object?> get props => [field];
}
