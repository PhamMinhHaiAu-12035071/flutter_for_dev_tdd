import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/authentication.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class HttpClient {
  Future<void> request(
      {required String url, required String method, Map? body});
}

class HttpClientSpy extends Mock implements HttpClient {}

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.secret};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

void main() {
  late HttpClient httpClient;
  late RemoteAuthentication sut;
  late String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpPostClient with correct URL', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    final body = {'email': params.email, 'password': params.secret};
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
}
