import 'dart:convert';

import 'package:flutter_for_dev_tdd/data/http/http.dart';
import "package:http/http.dart" as http;

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
    var response = http.Response('', 500);
    try {
      if (method == "post") {
        response = await client.post(Uri.parse(url),
            headers: headers, body: encodedBody);
      }
    } catch (_) {
      throw HttpError.serverError;
    }
    return _privateMethod(response);
  }

  Map? _privateMethod(http.Response response) {
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
    } else if (response.statusCode == 204 || response.body.isEmpty) {
      return null;
    }
    final Map json = jsonDecode(response.body);
    return json;
  }
}
