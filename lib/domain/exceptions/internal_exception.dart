import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';

import 'domain_exception.dart';

abstract class InternalException extends DomainException {}

class NotFoundException implements InternalException {
  @override
  String get message => R.strings.notFoundItems;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;

  @override
  String toString() => message;
}

class ReadFileStoredException implements InternalException {
  @override
  String get message => R.strings.readFileFailed;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;

  @override
  String toString() => message;
}
