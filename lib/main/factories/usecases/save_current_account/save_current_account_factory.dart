import 'package:flutter_for_dev_tdd/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/save_current_account.dart';
import 'package:flutter_for_dev_tdd/main/factories/cache/cache.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  final cacheStorage = makeLocalStorageAdapter();
  return LocalSaveCurrentAccount(cacheStorage: cacheStorage);
}
