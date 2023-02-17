import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter implements HttpClient {
  final http.Client client;

  HttpAdapter({required this.client});

  @override
  Future<Map> request(
      {required String url, required String method, Map? body}) async {
    final Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final response =
        await client.post(Uri.parse(url), headers: headers, body: body);
    final Map json = jsonDecode(response.body);
    return json;
  }
}

class ClientSpy extends Mock implements http.Client {}

void main() {
  late String url;
  late Uri uri;
  late Map<String, String> headers;
  late http.Client client;
  late HttpAdapter sut;

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

  tearDown(() {
    reset(client);
  });

  group('post', () {
    test('Should call post with correct values', () async {
      final body = {
        'any_key': 'any_value',
      };
      when(() => client.post(uri,
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
              (_) async => http.Response('{"any_key": "any_value"}', 200));
      await sut.request(url: url, method: 'post', body: body);
      verify(
          () => client.post(uri, headers: any(named: 'headers'), body: body));
    });

    test('Should call post without body', () async {
      when(() => client.post(uri, headers: any(named: 'headers'))).thenAnswer(
          (_) async => http.Response('{"any_key": "any_value"}', 200));
      await sut.request(url: url, method: 'post');
      verify(() => client.post(uri, headers: any(named: 'headers')));
    });

    test('Should return data if post returns 200', () async {
      when(() => client.post(uri, headers: headers)).thenAnswer(
          (_) async => http.Response('{"any_key": "any_value"}', 200));
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });
  });
}
