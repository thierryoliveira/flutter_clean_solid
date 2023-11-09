import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_solid/infra/http/http.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter({
    required this.client,
  });

  Future<void> request({
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
    await client.post(uri,
        headers: {...defaultHeaders, ...?headers}, body: jsonBody);
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

  group('post', () {
    test('should call post with correct values', () async {
      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((invocation) async => Response('anything', 200));

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

    test('should call post properly without body', () async {
      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((invocation) async => Response('anything', 200));

      await sut.request(url: url, method: HttpMethods.post);

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('should call post with correct custom headers', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((invocation) async => Response('anything', 200));

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
  });
}
