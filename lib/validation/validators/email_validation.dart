import 'package:equatable/equatable.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  final ValidationException? exception;

  const EmailValidation(this.field, [ValidationException? exception])
      : exception = exception ?? const EmailValidatorException();

  @override
  ValidationException? validate(String? value) {
    final regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value!);
    return isValid ? null : exception;
  }

  @override
  List<Object?> get props => [field];
}

class EmailValidatorException implements ValidationException {
  @override
  final String message = "Invalid email";

  const EmailValidatorException();

  @override
  String toString() => message;
}
