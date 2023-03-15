import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';

abstract class HttpException extends DomainException {}

class HttpInvalidCredentialsException extends HttpException {
  HttpInvalidCredentialsException();

  @override
  String get message => R.strings.httpInvalidCredentials;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

class HttpUnexpectedException extends HttpException {
  HttpUnexpectedException();

  @override
  String get message => R.strings.httpUnexpected;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}
