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
  test('Should call save secure with correct values', () async {
    final secureStorage = FlutterSecureStorageSpy();
    final sut = LocalStorageAdapter(secureStorage: secureStorage);
    final key = faker.lorem.word();
    final value = faker.guid.guid();
    when(() => secureStorage.write(key: key, value: value))
        .thenAnswer((_) async => Future.value);
    await sut.saveSecure(key: key, value: value);
    verify(() => secureStorage.write(key: key, value: value)).called(1);
  });
}
