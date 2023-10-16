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
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthenticationUsecase(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
  });

  test('should calls HttpClient with the correct URL', () async {
    when(() => httpClient.request(
              url: any(named: 'url'),
              method: any(named: 'method'),
              body: any(named: 'body'),
            ))
        .thenAnswer((invocation) async =>
            {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

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

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throws UnexpectedError if Httpclient returns 404', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.notFound);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throws UnexpectedError if Httpclient returns 500', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.serverError);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throws UnexpectedError if Httpclient returns 500', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.serverError);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throws InvalidCredentialsError if Httpclient returns 401',
      () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('should return AccountEntity if Httpclient returns 200', () async {
    final token = faker.guid.guid();

    when(() => httpClient.request(
              url: any(named: 'url'),
              method: any(named: 'method'),
              body: any(named: 'body'),
            ))
        .thenAnswer(
            (_) async => {'accessToken': token, 'name': faker.person.name()});

    final response = await sut.auth(params: params);

    expect(response.token, token);
  });

  test(
      'should throws UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {'invalid_key': 'invalid_value'});

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
