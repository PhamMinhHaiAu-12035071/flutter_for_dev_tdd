import 'package:dio/dio.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';

class DioAdapter implements HttpClient {
  final Dio client;

  DioAdapter({required this.client});

  @override
  Future<Map> request(
      {required String url,
      required String method,
      Map? body,
      dynamic options}) async {
    final response = await client.post(url, data: body, options: options);
    return response.data;
  }
}
