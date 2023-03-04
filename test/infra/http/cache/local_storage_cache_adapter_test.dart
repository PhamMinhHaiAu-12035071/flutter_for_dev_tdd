import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/cache/cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({required this.secureStorage});

  @override
  Future<void> saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorage secureStorage;
  late LocalStorageAdapter sut;
  late String key;
  late String value;

  When mockSaveSecureCall() => when(() =>
      secureStorage.write(key: any(named: 'key'), value: any(named: 'value')));

  void mockSaveSecureError() {
    mockSaveSecureCall().thenThrow(Exception());
  }

  void mockSaveSecureSuccess() {
    mockSaveSecureCall().thenAnswer((_) async => Future.value);
  }

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
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
}
