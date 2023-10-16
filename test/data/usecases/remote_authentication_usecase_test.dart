import 'package:faker/faker.dart';
import 'package:flutter_clean_solid/data/http/http.dart';
import 'package:flutter_clean_solid/data/usecases/usecases.dart';
import 'package:flutter_clean_solid/domain/helpers/helpers.dart';
import 'package:flutter_clean_solid/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthenticationUsecase sut;
  late HttpClient httpClient;
  late String url;
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthenticationUsecase(httpClient: httpClient, url: url);
  });

  test('should calls HttpClient with the correct URL', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((invocation) => Future.value());

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    await sut.auth(params: params);

    verify(() => httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password}));
  });

  test('should throws UnexpectedError if Httpclient returns 400', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
