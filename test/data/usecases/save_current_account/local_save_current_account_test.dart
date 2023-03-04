import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveCacheStorage cacheStorage;

  LocalSaveCurrentAccount({required this.cacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    await cacheStorage.saveSecure(key: 'token', value: account.token);
  }
}

class SaveCacheStorageSpy extends Mock implements SaveCacheStorage {}

abstract class SaveCacheStorage {
  Future<void> saveSecure({required String key, required String value});
}

void main() {
  test('Should call SaveCacheStorage with correct values', () async {
    final cacheStorage = SaveCacheStorageSpy();
    when(() => cacheStorage.saveSecure(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) async => Future.value);
    final sut = LocalSaveCurrentAccount(cacheStorage: cacheStorage);
    final account = AccountEntity(faker.guid.guid());
    await sut.save(account);
    verify(() => cacheStorage.saveSecure(key: 'token', value: account.token));
  });
}
