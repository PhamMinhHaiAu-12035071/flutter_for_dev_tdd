import 'package:flutter_for_dev_tdd/data/usecases/load_current_account/load_current_account.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/load_current_account.dart';
import 'package:flutter_for_dev_tdd/main/factories/cache/cache.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  final fetchSecureCacheStorage = makeLocalStorageAdapter();
  return LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage);
}
