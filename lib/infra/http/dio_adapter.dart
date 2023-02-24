import 'package:dio/dio.dart';
import 'package:flutter_for_dev_tdd/data/http/http.dart';

class DioAdapter implements HttpClient {
  final Dio client;

  DioAdapter({required this.client});

  @override
  Future<Map?> request(
      {required String url,
      required String method,
      Map? body,
      dynamic options}) async {
    final response = await client.post(url, data: body, options: options);
    return _handleResponse(response);
  }

  Map? _handleResponse(Response response) {
    if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else if (response.statusCode == 500) {
      throw HttpError.serverError;
    } else if (response.data.isEmpty) {
      return null;
    }
    return response.data;
  }
}
