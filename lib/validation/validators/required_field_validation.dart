import 'package:equatable/equatable.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  final ValidationException exception;

  RequiredFieldValidation(this.field, [ValidationException? exception])
      : exception = exception ?? RequiredFieldValidatorExceptions();

  @override
  ValidationException? validate(String? value) {
    return value?.isEmpty == false ? null : RequiredFieldValidatorExceptions();
  }

  @override
  List<Object?> get props => [field];
}

class RequiredFieldValidatorExceptions implements ValidationException {
  @override
  final String message = R.strings.msgRequiredField;

  @override
  String toString() => message;
}
