import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/data/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/domain/exceptions/exceptions.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late AddAccountParams params;
  late String password;
  late String url;
  late HttpClient httpClient;
  late AddAccount sut;

  Map mockResponseData() => {
        "success": true,
        "message": faker.lorem.sentence(),
        "token": faker.guid.guid(),
        "errors": [],
        "status": faker.randomGenerator.integer(200),
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
    password = faker.internet.password();
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: password,
      passwordConfirmation: password,
    );
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
  });
  test('Should call HttpClient with correct values', () async {
    final body = RemoteAddAccountParams.fromDomain(params).toJSON();
    final response = mockResponseData();
    mockHttpData(response);
    await sut.add(params);

    verify(() => httpClient.request(
          url: url,
          method: 'post',
          body: body,
        )).called(1);
  });

  test('Should throw HttpUnexpectedException if HttpClient return 400',
      () async {
    mockHttpError(HttpError.badRequest);
    final futureResult = sut.add(params);

    expect(futureResult, throwsA(isA<HttpUnexpectedException>()));
  });

  test('Should throw HttpUnexpectedException if HttpClient return 500',
      () async {
    mockHttpError(HttpError.serverError);
    final futureResult = sut.add(params);

    expect(futureResult, throwsA(isA<HttpUnexpectedException>()));
  });

  test('Should return an AccountEntity if HttpClient return 200', () async {
    final response = mockResponseData();
    mockHttpData(response);
    final account = await sut.add(params);

    expect(account.token, response['token']);
  });

  test(
      'Should throw HttpUnexpectedException if HttpClient return 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});
    final futureResult = sut.add(params);

    expect(futureResult, throwsA(isA<HttpUnexpectedException>()));
  });
}
