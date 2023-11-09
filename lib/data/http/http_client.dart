import 'package:flutter_clean_solid/infra/http/http_methods.dart';

abstract class HttpClient {
  Future<Map<String, dynamic>> request({
    required String url,
    required HttpMethods method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  });
}
