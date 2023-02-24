import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';
import 'package:flutter_for_dev_tdd/infra/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DioSpy extends Mock implements Dio {}

class OptionSpy extends Mock implements Options {}

void main() {
  late String url;
  late Dio client;
  late DioAdapter sut;
  late Options options;
  setUp(() {
    url = faker.internet.httpUrl();
    options = OptionSpy();
    client = DioSpy();
    sut = DioAdapter(client: client);
  });

  tearDown(() {
    reset(options);
    reset(client);
  });

  When mockHeaders() => when(() => options.headers);

  void mockHeaderReturn() {
    final headers = {
      Headers.contentTypeHeader: 'application/json',
      Headers.acceptHeader: 'application/json',
    };
    mockHeaders().thenReturn(headers);
  }

  When mockRequest() => when(() => client.post(
        url,
        data: any(named: 'data'),
        options: any(named: 'options'),
      ));

  void mockResponse(int statusCode, {Map body = const {}}) {
    mockRequest().thenAnswer((_) async => Response(
          data: body,
          statusCode: statusCode,
          requestOptions: RequestOptions(),
        ));
  }

  group('shared', () {
    test('Should throw ServerError if invalid method is provider', () async {
      final future = sut.request(url: url, method: 'invalid_method');
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    setUp(() {
      mockHeaderReturn();
      mockResponse(200);
    });
    test('Should call post with correct values', () async {
      final body = {
        'any_key': 'any_value',
      };
      await sut.request(url: url, method: 'post', body: body, options: options);
      expect(options.headers, {
        Headers.contentTypeHeader: 'application/json',
        Headers.acceptHeader: 'application/json',
      });
      verify(() => client.post(url, data: body, options: options));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post', options: options);
      verify(() => client.post(url, options: options));
    });

    test('Should call post without options', () async {
      await sut.request(url: url, method: 'post');
      verify(() => client.post(url));
    });

    test('Should call post with options', () async {
      await sut.request(url: url, method: 'post', options: options);
      verify(() => client.post(url, options: options));
    });

    test('Should return data if post returns 200', () async {
      final body = {
        'any_key': 'any_value',
      };
      mockResponse(200, body: body);
      final response = await sut.request(
          url: url, method: 'post', body: body, options: options);
      expect(response, body);
    });

    test('Should return null if post returns 200 with no data', () async {
      final response =
          await sut.request(url: url, method: 'post', options: options);
      expect(response, null);
    });
    test('Should return null if post returns 204 with no data', () async {
      mockResponse(204);
      final response =
          await sut.request(url: url, method: 'post', options: options);
      expect(response, null);
    });
    test('Should return BadRequest if post returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post', options: options);
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'post', options: options);
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'post', options: options);
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'post', options: options);
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
