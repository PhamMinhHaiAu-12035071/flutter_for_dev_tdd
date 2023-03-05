import 'package:equatable/equatable.dart';
import 'package:flutter_for_dev_tdd/validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    return value?.isEmpty == false ? null : 'Field is not empty';
  }

  @override
  List<Object?> get props => [field];
}
