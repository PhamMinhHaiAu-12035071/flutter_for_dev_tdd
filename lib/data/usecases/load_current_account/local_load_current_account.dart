import 'package:flutter_for_dev_tdd/data/cache/cache.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  @override
  Future<AccountEntity?> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      if (token == null) {
        throw NotFoundException();
      }
      return AccountEntity(token);
    } on NotFoundException {
      rethrow;
    } catch (_) {
      throw ReadFileStoredException();
    }
  }
}
