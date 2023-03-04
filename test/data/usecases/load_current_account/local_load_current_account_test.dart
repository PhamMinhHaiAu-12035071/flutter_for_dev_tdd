import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

abstract class LoadCurrentAccount {
  Future<AccountEntity> load();
}

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  @override
  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      return AccountEntity(token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

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

  void mockFetchSecureResult() {
    mockFetchSecure().thenAnswer((_) async => token);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecureResult();
  });

  test('Should call FetchSecureCacheStorage with correct values', () async {
    await sut.load();
    verify(() => fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return AccountEntity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token));
  });
  test('Should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
