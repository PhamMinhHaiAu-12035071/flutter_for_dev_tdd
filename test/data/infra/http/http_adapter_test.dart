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
  Future<Map?> request(
      {required String url, required String method, Map? body}) async {
    final Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final encodedBody = body != null ? jsonEncode(body) : null;
    final response =
        await client.post(Uri.parse(url), headers: headers, body: encodedBody);
    if(response.statusCode == 204 || response.body.isEmpty) {
      return null;
    }
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
    When mockRequest() => when(() => client.post(
          uri,
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ));

    void mockResponse(int statusCode,
        {String body = '{"any_key": "any_value"}'}) {
      mockRequest().thenAnswer((_) async => http.Response(
            body,
            statusCode,
          ));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      final body = {
        'any_key': 'any_value',
      };
      mockResponse(200, body: jsonEncode(body));
      await sut.request(url: url, method: 'post', body: body);
      verify(() => client.post(uri,
          headers: any(named: 'headers'), body: any(named: 'body')));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post');
      verify(() => client.post(uri, headers: any(named: 'headers')));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: "");
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204 with no data', () async {
      mockResponse(204, body: "");
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
  });
}
