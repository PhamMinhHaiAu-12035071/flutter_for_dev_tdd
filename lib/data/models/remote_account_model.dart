import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (json.containsKey('accessToken') == false) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
