import 'package:flutter_for_dev_tdd/domain/helpers/helpers.dart';

abstract class Validation {
  ValidationException? validate({required String field, required String value});
}

abstract class ValidationException implements DomainException {
  @override
  String get message;
}

class CommonValidationException implements ValidationException {
  @override
  final String message;

  CommonValidationException(this.message);

  @override
  String toString() => message;
}
