import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String secret;

  AuthenticationParams({required this.email, required this.secret});

  Map toJSON() {
    return {'email': email, 'password': secret};
  }
}
