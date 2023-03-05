import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';

abstract class Validation {
  ValidationException? validate({required String field, required String value});
}

abstract class ValidationException extends DomainException {}

class CommonValidationException implements ValidationException {
  @override
  final String message;

  CommonValidationException(this.message);

  @override
  String toString() => message;
}
