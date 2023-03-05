import 'package:equatable/equatable.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  final ValidationException exception;

  const RequiredFieldValidation(this.field, [ValidationException? exception])
      : exception = exception ?? const RequiredFieldValidatorExceptions();

  @override
  ValidationException? validate(String? value) {
    return value?.isEmpty == false
        ? null
        : const RequiredFieldValidatorExceptions();
  }

  @override
  List<Object?> get props => [field];
}

class RequiredFieldValidatorExceptions implements ValidationException {
  @override
  final String message = "Field is not empty";

  const RequiredFieldValidatorExceptions();

  @override
  String toString() => message;
}
