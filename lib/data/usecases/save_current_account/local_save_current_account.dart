import 'dart:io';

import 'package:flutter_for_dev_tdd/data/cache/cache.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/utils/i18n/i18n.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage cacheStorage;

  LocalSaveCurrentAccount({required this.cacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await cacheStorage.saveSecure(key: 'token', value: account.token);
    } catch (_) {
      throw FileSystemException(R.strings.fileSystemException);
    }
  }
}
