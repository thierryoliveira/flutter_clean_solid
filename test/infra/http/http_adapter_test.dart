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
  }) async {
    final defaultHeaders = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final uri = Uri.parse(url);
    await client.post(uri, headers: {...defaultHeaders, ...?headers});
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

  test('should call post with correct values', () async {
    when(() => client.post(any()))
        .thenAnswer((invocation) async => Response('anything', 200));

    await sut.request(url: url, method: HttpMethods.post);

    verify(() => client.post(uri));
  });

  test('should call post with correct values', () async {
    when(() => client.post(any()))
        .thenAnswer((invocation) async => Response('anything', 200));

    await sut.request(url: url, method: HttpMethods.post);

    verify(() => client.post(uri));
  });

  test('should call post with correct headers', () async {
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
}
