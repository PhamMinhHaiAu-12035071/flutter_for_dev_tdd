import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_for_dev_tdd/infra/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DioSpy extends Mock implements Dio {}

class OptionSpy extends Mock implements Options {}

void main() {
  late String url;
  late Dio client;
  late DioAdapter sut;
  late OptionSpy options;
  setUp(() {
    url = faker.internet.httpUrl();
    options = OptionSpy();
    client = DioSpy();
    sut = DioAdapter(client: client);
  });

  When mockHeaders() => when(() => options.headers);

  void mockHeaderReturn() {
    final headers = {
      Headers.contentTypeHeader: 'application/json',
      Headers.acceptHeader: 'application/json',
    };
    mockHeaders().thenReturn(headers);
  }

  group('post', () {
    test('Should call post with correct values', () async {
      final body = {
        'any_key': 'any_value',
      };

      mockHeaderReturn();
      when(() => client.post(url, data: body, options: options))
          .thenAnswer((_) async => Response(
                data: body,
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      await sut.request(url: url, method: 'post', body: body, options: options);
      expect(options.headers, {
        Headers.contentTypeHeader: 'application/json',
        Headers.acceptHeader: 'application/json',
      });
      verify(() => client.post(url, data: body, options: options));
    });

    test('Should call post without body', () async {
      mockHeaderReturn();
      when(() => client.post(url, options: options))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      await sut.request(url: url, method: 'post', options: options);
      verify(() => client.post(url, options: options));
    });

    test('Should call post without options', () async {
      when(() => client.post(url)).thenAnswer((_) async => Response(
            data: {},
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));
      await sut.request(url: url, method: 'post');
      verify(() => client.post(url));
    });

    test('Should call post with options', () async {
      mockHeaderReturn();
      when(() => client.post(url, options: options))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      await sut.request(url: url, method: 'post', options: options);
      verify(() => client.post(url, options: options));
    });
  });
}
