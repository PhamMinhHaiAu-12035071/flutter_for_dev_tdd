import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';
import 'package:flutter_for_dev_tdd/domain/helpers/helpers.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage cacheStorage;

  LocalSaveCurrentAccount({required this.cacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await cacheStorage.saveSecure(key: 'token', value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

class SaveSecureCacheStorageSpy extends Mock
    implements SaveSecureCacheStorage {}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({required String key, required String value});
}

void main() {
  test('Should call SaveCacheStorage with correct values', () async {
    final cacheStorage = SaveSecureCacheStorageSpy();
    when(() => cacheStorage.saveSecure(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async => Future.value);
    final sut = LocalSaveCurrentAccount(cacheStorage: cacheStorage);
    final account = AccountEntity(faker.guid.guid());
    await sut.save(account);
    verify(() => cacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveCacheStorage throws', () async {
    final cacheStorage = SaveSecureCacheStorageSpy();
    when(() => cacheStorage.saveSecure(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenThrow(Exception());
    final sut = LocalSaveCurrentAccount(cacheStorage: cacheStorage);
    final account = AccountEntity(faker.guid.guid());
    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpected));
  });
}
