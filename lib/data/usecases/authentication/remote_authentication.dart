import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/data/models/models.dart';
import 'package:flutter_for_dev_tdd/domain/entities/entities.dart';
import 'package:flutter_for_dev_tdd/domain/helpers/helpers.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJSON();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse ?? {}).toEntity();
    } on HttpError catch (error) {
      if (error == HttpError.unauthorized) {
        throw DomainError.invalidCredentials;
      }
      throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) {
    return RemoteAuthenticationParams(
      email: entity.email,
      password: entity.secret,
    );
  }

  Map toJSON() {
    return {'username': email, 'password': password};
  }
}
