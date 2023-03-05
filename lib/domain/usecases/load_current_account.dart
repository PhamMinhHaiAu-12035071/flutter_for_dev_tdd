import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity?> load();
}
