import '../exceptions/domain_exception.dart';

abstract class HttpException extends DomainException {}

class HttpInvalidCredentialsException extends HttpException {
  HttpInvalidCredentialsException();

  @override
  String get message => 'Credentials are invalid.';
}

class HttpUnexpectedException extends HttpException {
  HttpUnexpectedException();

  @override
  String get message => 'Unexpected error. Try again later.';
}
