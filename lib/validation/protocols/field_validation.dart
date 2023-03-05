import 'package:flutter_for_dev_tdd/presentation/protocols/protocols.dart';

abstract class FieldValidation {
  String get field;
  ValidationException? validate(String? value);
}
