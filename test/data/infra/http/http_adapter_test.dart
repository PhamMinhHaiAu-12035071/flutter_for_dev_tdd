import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter({required this.client});

  Future<void> request(
      {required String url, required String method, Map? body}) async {
    final Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client.post(Uri.parse(url), headers: headers);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('post', () {
    test('Should call post with correct values', () async {
      final url = faker.internet.httpUrl();
      final uri = Uri.parse(url);
      final Map<String, String> headers = {
        'content-type': 'application/json',
        'accept': 'application/json',
      };
      final client = ClientSpy();
      when(() => client.post(uri, headers: headers))
          .thenAnswer((_) async => Response('', 200));
      final sut = HttpAdapter(client: client);
      await sut.request(url: url, method: 'post');
      verify(() => client.post(uri, headers: headers));
    });
  });
}
