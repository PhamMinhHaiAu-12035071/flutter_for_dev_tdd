import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/data/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/authentication.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late Authentication sut;
  late String url;
  late AuthenticationParams params;

  Map mockResponseData() => {
        'token': faker.guid.guid(),
        'name': faker.person.name(),
      };

  When mockRequest() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockResponseData());
  });

  test('Should call HttpClient with correct values', () async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJSON();
    final response = mockResponseData();
    mockHttpData(response);
    await sut.auth(params);

    verify(
      () => httpClient.request(
        url: url,
        method: 'post',
        body: body,
      ),
    ).called(1);
  });

  test('Should throw HttpUnexpectedException if HttpClient return 400',
      () async {
    mockHttpError(HttpError.badRequest);
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(isA<HttpUnexpectedException>()));
  });

  test('Should throw HttpUnexpectedException if HttpClient return 404',
      () async {
    mockHttpError(HttpError.notFound);
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(isA<HttpUnexpectedException>()));
  });

  test('Should throw HttpUnexpectedException if HttpClient return 500',
      () async {
    mockHttpError(HttpError.serverError);
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(isA<HttpUnexpectedException>()));
  });

  test('Should throw HttpInvalidCredentialsException if HttpClient return 401',
      () async {
    mockHttpError(HttpError.unauthorized);
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(isA<HttpInvalidCredentialsException>()));
  });

  test('Should return an AccountEntity if HttpClient return 200', () async {
    final response = mockResponseData();
    mockHttpData(response);
    final account = await sut.auth(params);

    expect(account.token, response['token']);
  });

  test(
      'Should throw HttpUnexpectedException if HttpClient return 200 with invalid data',
      () async {
    mockHttpData({
      'invalid_key': 'invalid_value',
    });
    final futureResult = sut.auth(params);

    expect(futureResult, throwsA(isA<HttpUnexpectedException>()));
  });
}
