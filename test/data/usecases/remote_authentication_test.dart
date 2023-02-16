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

  test('Should call HttpPostClient with correct URL', () async {
    final body = params.toJSON();
    when(() => httpClient.request(url: url, method: 'post', body: body))
        .thenAnswer((_) async => {});
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
}
