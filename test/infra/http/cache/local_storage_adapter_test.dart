import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/infra/cache/cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorage secureStorage;
  late LocalStorageAdapter sut;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
    When mockSaveSecureCall() => when(() => secureStorage.write(
        key: any(named: 'key'), value: any(named: 'value')));

    void mockSaveSecureError() {
      mockSaveSecureCall().thenThrow(Exception());
    }

    void mockSaveSecureSuccess() {
      mockSaveSecureCall().thenAnswer((_) async => Future.value);
    }

    setUp(() {
      mockSaveSecureSuccess();
    });
    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);
      verify(() => secureStorage.write(key: key, value: value)).called(1);
    });

    test('Should throw if save secure throws', () async {
      mockSaveSecureError();
      final future = sut.saveSecure(key: key, value: value);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    late String token;
    When mockFetchSecureCall() =>
        when(() => secureStorage.read(key: any(named: 'key')));

    void mockFetchSecureError() {
      mockFetchSecureCall().thenThrow(Exception());
    }

    void mockFetchSecureSuccess([String? token]) {
      mockFetchSecureCall().thenAnswer((_) async => token);
    }

    setUp(() {
      token = faker.guid.guid();
      mockFetchSecureSuccess(token);
    });
    test('Should call fetch secure with correct values', () async {
      await sut.fetchSecure(key);
      verify(() => secureStorage.read(key: key)).called(1);
    });

    test('Should return correct value on success', () async {
      final fetchedToken = await sut.fetchSecure(key);
      expect(fetchedToken, token);
    });
    test('Should return null if fetch secure returns null', () async {
      mockFetchSecureSuccess();
      final fetchedToken = await sut.fetchSecure(key);
      expect(fetchedToken, null);
    });
    test('Should throw if fetch secure throws', () async {
      mockFetchSecureError();
      final future = sut.fetchSecure(key);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
