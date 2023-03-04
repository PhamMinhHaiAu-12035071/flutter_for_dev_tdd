import 'package:equatable/equatable.dart';
import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String secret;

  const AuthenticationParams({required this.email, required this.secret});

  Map toJSON() {
    return {'username': email, 'password': secret};
  }

  @override
  List<Object?> get props => [email, secret];
}
