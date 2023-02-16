import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/data/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/domain/helpers/domain_error.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/authentication.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late RemoteAuthentication sut;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Should call HttpClient with correct values', () async {
    final body = params.toJSON();
    final accessToken = faker.guid.guid();
    when(() => httpClient.request(url: url, method: 'post', body: body))
        .thenAnswer((_) async => ({
              'accessToken': accessToken,
              'name': faker.person.name(),
            }));
    await sut.auth(params);

    verify(
      () => httpClient.request(
        url: url,
        method: 'post',
        body: body,
      ),
    ).called(1);
  });

  test('Should throw UnexpectedError if HttpClient return 400', () async {
    final body = params.toJSON();
    when(() => httpClient.request(url: url, method: 'post', body: body))
        .thenThrow(HttpError.badRequest);
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    final body = params.toJSON();
    when(() => httpClient.request(url: url, method: 'post', body: body))
        .thenThrow(HttpError.notFound);
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () async {
    final body = params.toJSON();
    when(() => httpClient.request(url: url, method: 'post', body: body))
        .thenThrow(HttpError.serverError);
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient return 401',
      () async {
    final body = params.toJSON();
    when(() => httpClient.request(url: url, method: 'post', body: body))
        .thenThrow(HttpError.unauthorized);
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient return 200', () async {
    final body = params.toJSON();
    final accessToken = faker.guid.guid();
    when(() => httpClient.request(url: url, method: 'post', body: body))
        .thenAnswer((_) async => ({
              'accessToken': accessToken,
              'name': faker.person.name(),
            }));
    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });

  test(
      'Should throw UnexpectedError if HttpClient return 200 with invalid data',
      () async {
    final body = params.toJSON();
    when(() => httpClient.request(url: url, method: 'post', body: body))
        .thenAnswer((_) async => ({
              'invalid_key': 'invalid_value',
            }));
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(DomainError.unexpected));
  });
}
