import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/cache/cache.dart';
import 'package:flutter_for_dev_tdd/data/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorage fetchSecureCacheStorage;
  late LoadCurrentAccount sut;
  late String token;

  When mockFetchSecure() =>
      when(() => fetchSecureCacheStorage.fetchSecure(any()));

  void mockFetchSecureError() {
    mockFetchSecure().thenThrow(Exception());
  }

  void mockFetchSecureResult(String? token) {
    mockFetchSecure().thenAnswer((_) async => token);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecureResult(token);
  });

  test('Should call FetchSecureCacheStorage with correct values', () async {
    await sut.load();
    verify(() => fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return AccountEntity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token));
  });
  test('Should throw ReadFileStoredException if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureError();
    final future = sut.load();
    expect(future, throwsA(isA<ReadFileStoredException>()));
  });

  test('Should throw NotFoundException if FetchSecureCacheStorage return null',
      () async {
    mockFetchSecureResult(null);
    final account = sut.load();
    expect(account, throwsA(isA<NotFoundException>()));
  });
}
