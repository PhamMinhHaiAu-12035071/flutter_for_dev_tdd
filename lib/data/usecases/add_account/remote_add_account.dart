import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/data/models/models.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> add(AddAccountParams params) async {
    try {
      final body = RemoteAddAccountParams.fromDomain(params).toJSON();
      final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: body,
      );
      return RemoteAccountModel.fromJson(httpResponse ?? {}).toEntity();
    } on HttpError catch (_) {
      throw HttpUnexpectedException();
    }
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams entity) {
    return RemoteAddAccountParams(
      name: entity.name,
      email: entity.email,
      password: entity.password,
      passwordConfirmation: entity.passwordConfirmation,
    );
  }

  Map toJSON() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
