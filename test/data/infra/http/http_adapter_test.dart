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
    await client.post(Uri.parse(url), headers: headers, body: body);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late final String url;
  late final Uri uri;
  late final Map<String, String> headers;
  late final ClientSpy client;
  late final HttpAdapter sut;

  setUp(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
    headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    client = ClientSpy();
    sut = HttpAdapter(client: client);
  });

  group('post', () {
    test('Should call post with correct values', () async {
      final body = {
        'any_key': 'any_value',
      };
      when(() => client.post(uri, headers: headers, body: body))
          .thenAnswer((_) async => Response('', 200));
      await sut.request(url: url, method: 'post', body: body);
      verify(() => client.post(uri, headers: headers, body: body)).called(1);
    });
  });
}
