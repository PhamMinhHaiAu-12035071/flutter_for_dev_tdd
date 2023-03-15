import 'package:equatable/equatable.dart';

abstract class DomainException extends Equatable implements Exception {
  String get message;

  @override
  String toString() => message;
}
