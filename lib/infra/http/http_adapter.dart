import 'dart:convert';

import 'package:flutter_clean_solid/infra/http/http_status_codes.dart';
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
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == HttpStatusCodes.ok.code &&
        response.body.isNotEmpty) {
      return jsonDecode(response.body);
    } else if (response.statusCode == HttpStatusCodes.noContent.code ||
        response.body.isEmpty) {
      return {};
    } else if (response.statusCode == HttpStatusCodes.badRequest.code) {
      throw HttpError.badRequest;
    }
    throw HttpError.serverError;
  }
}
