import 'dart:convert';

import 'package:flutter_for_dev_tdd/data/http/http_client.dart';
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
    final response =
        await client.post(Uri.parse(url), headers: headers, body: encodedBody);
    if (response.statusCode == 204 || response.body.isEmpty) {
      return null;
    }
    final Map json = jsonDecode(response.body);
    return json;
  }
}
