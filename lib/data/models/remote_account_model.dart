import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel(this.token);

  factory RemoteAccountModel.fromJson(Map json) {
    if (json.containsKey('token') == false) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['token']);
  }

  AccountEntity toEntity() => AccountEntity(token);
}
