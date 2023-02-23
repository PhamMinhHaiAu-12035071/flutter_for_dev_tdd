import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/infra/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements http.Client {}

void main() {
  late String url;
  late Uri uri;
  late http.Client client;
  late HttpAdapter sut;

  setUp(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
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

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204, body: "");
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should return BadRequest if post returns 400', () async {
      mockResponse(400);
      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);
      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      mockResponse(403);
      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.forbidden));
    });

    test('Should return ForbiddenError if post returns 404', () async {
      mockResponse(404);
      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);
      final response = sut.request(url: url, method: 'post');

      expect(response, throwsA(HttpError.serverError));
    });
  });
}
