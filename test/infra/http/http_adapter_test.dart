import 'package:faker/faker.dart';
import 'package:flutter_clean_solid/data/http/http_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_solid/infra/http/http.dart';

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
    When mockRequest() => when(() => client.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body')));

    void mockResponse(
        {int statusCode = 200, String body = '{"country":"Brazil"}'}) {
      mockRequest()
          .thenAnswer((invocation) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse();
    });

    test('should request with correct values', () async {
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
      await sut.request(url: url, method: HttpMethods.post);

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('should request with correct custom headers', () async {
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
      final response = await sut.request(url: url, method: HttpMethods.post);

      expect(response, {'country': 'Brazil'});

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('should return empty map if post returns 200 with empty body',
        () async {
      mockResponse(body: '');

      final response = await sut.request(url: url, method: HttpMethods.post);

      expect(response, {});

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('should return empty map if post returns 204', () async {
      mockResponse(statusCode: 204, body: '');

      final response = await sut.request(url: url, method: HttpMethods.post);

      expect(response, {});

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('should return empty map if post returns 204 with data in the body',
        () async {
      mockResponse(statusCode: 204);

      final response = await sut.request(url: url, method: HttpMethods.post);

      expect(response, {});

      verify(() => client.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ));
    });

    test('should return BadRequestError if post returns 400', () async {
      mockResponse(statusCode: 400);

      final futureException = sut.request(url: url, method: HttpMethods.post);

      expect(futureException, throwsA(HttpError.badRequest));
    });
  });
}
