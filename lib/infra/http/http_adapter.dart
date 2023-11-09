import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';
import 'http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter({
    required this.client,
  });

  @override
  Future<Map<String, dynamic>> request({
    required String url,
    required HttpMethods method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    final defaultHeaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final uri = Uri.parse(url);
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(uri,
        headers: {...defaultHeaders, ...?headers}, body: jsonBody);
    return response.body.isEmpty || response.statusCode == 204
        ? {}
        : jsonDecode(response.body);
  }
}
