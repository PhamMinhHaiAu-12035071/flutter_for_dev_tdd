import 'package:flutter_for_dev_tdd/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    return RemoteAccountModel(json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
