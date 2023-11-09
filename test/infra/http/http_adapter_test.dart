import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_clean_solid/data/http/http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_solid/infra/http/http.dart';

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
    return response.body.isNotEmpty ? jsonDecode(response.body) : {};
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;
  late Uri uri;

  setUpAll(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
    registerFallbackValue(uri);
  });

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
  });

  group('post:', () {
    test('should request with correct values', () async {
      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
              (invocation) async => Response('{"country":"Brazil"}', 200));

      await sut.request(url: url, method: HttpMethods.post, body: {
        'any_key': 'any_value',
      });

      verify(() => client.post(
            uri,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
            body: '{"any_key":"any_value"}',
          ));
    });

    test('should request properly without body', () async {
      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
              (invocation) async => Response('{"country":"Brazil"}', 200));

      await sut.request(url: url, method: HttpMethods.post);

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('should request with correct custom headers', () async {
      when(() => client.post(any(), headers: any(named: 'headers'))).thenAnswer(
          (invocation) async => Response('{"country":"Brazil"}', 200));

      await sut.request(
        url: url,
        method: HttpMethods.post,
        headers: {
          'custom-header': 'custom-value',
        },
      );

      verify(() => client.post(
            uri,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
              'custom-header': 'custom-value',
            },
          ));
    });

    test('should return data if post returns 200', () async {
      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer(
              (invocation) async => Response('{"country":"Brazil"}', 200));

      final response = await sut.request(url: url, method: HttpMethods.post);

      expect(response, {'country': 'Brazil'});

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('should return empty map if post returns 200 with empty body',
        () async {
      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((invocation) async => Response('', 200));

      final response = await sut.request(url: url, method: HttpMethods.post);

      expect(response, {});

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });
  });
}
