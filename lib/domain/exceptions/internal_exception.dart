import 'domain_exception.dart';

abstract class InternalException extends DomainException {}

class NotFoundException implements InternalException {
  @override
  String get message => 'Not found items';
}

class ReadFileStoredException implements InternalException {
  @override
  String get message => 'read file failed';
}

class WriteFileStoredException implements InternalException {
  @override
  String get message => 'Write file failed';
}
