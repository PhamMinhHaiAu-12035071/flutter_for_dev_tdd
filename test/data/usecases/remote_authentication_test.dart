import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class HttpClient {
  Future<void> request({required String url, required String method});
}

class HttpClientSpy extends Mock implements HttpClient {}

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

void main() {
  late HttpClient httpClient;
  late RemoteAuthentication sut;
  late String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    when(() => httpClient.request(url: url, method: 'post')).thenAnswer((
        _) async => {});
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpPostClient with correct URL', () async {
    await sut.auth();

    verify(() => httpClient.request(url: url, method: 'post')).called(1);
  });
}


