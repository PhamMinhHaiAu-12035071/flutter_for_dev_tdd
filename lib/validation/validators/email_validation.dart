import 'package:equatable/equatable.dart';
import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  final ValidationException? exception;

  EmailValidation(this.field, [ValidationException? exception])
      : exception = exception ?? EmailValidatorException();

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
  final String message = R.strings.msgInvalidEmail;

  EmailValidatorException();

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}
