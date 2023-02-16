import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/data/usecases/usecases.dart';
import 'package:flutter_for_dev_tdd/domain/usecases/authentication.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

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
}
