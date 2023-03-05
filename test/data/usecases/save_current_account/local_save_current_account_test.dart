import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/cache/cache.dart';
import 'package:flutter_for_dev_tdd/data/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class SaveSecureCacheStorageSpy extends Mock
    implements SaveSecureCacheStorage {}

void main() {
  late SaveSecureCacheStorage cacheStorage;
  late SaveCurrentAccount sut;
  late AccountEntity account;

  When mockCacheStorage() => when(() => cacheStorage.saveSecure(
      key: any(named: 'key'), value: any(named: 'value')));

  void mockCacheStorageResult() {
    mockCacheStorage().thenAnswer((_) async => Future.value);
  }

  void mockCacheError() {
    mockCacheStorage().thenThrow(Exception());
  }

  setUp(() {
    cacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(cacheStorage: cacheStorage);
    account = AccountEntity(faker.guid.guid());
    mockCacheStorageResult();
  });

  test('Should call SaveCacheStorage with correct values', () async {
    await sut.save(account);
    verify(() => cacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw WriteFileStoredException if SaveCacheStorage throws',
      () async {
    mockCacheError();
    final future = sut.save(account);
    expect(future, throwsA(isA<WriteFileStoredException>()));
  });
}
