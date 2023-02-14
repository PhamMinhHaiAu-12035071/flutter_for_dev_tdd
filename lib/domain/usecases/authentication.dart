import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required String email, required String password});
}
