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
  late Map<String, dynamic> validData;

  When mockRequest() {
    return when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ));
  }

  void mockHttpSuccess(Map<String, dynamic> data) {
    return mockRequest().thenAnswer((invocation) async => data);
  }

  void mockHttpError(HttpError error) {
    return mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthenticationUsecase(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    validData = {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

    mockHttpSuccess(validData);
  });

  test('should calls HttpClient with the correct URL', () async {
    await sut.auth(params: params);

    verify(() => httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password}));
  });

  test('should throws UnexpectedError if Httpclient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throws UnexpectedError if Httpclient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throws UnexpectedError if Httpclient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throws InvalidCredentialsError if Httpclient returns 401',
      () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('should return AccountEntity if Httpclient returns 200', () async {
    final response = await sut.auth(params: params);

    expect(response.token, validData['accessToken']);
  });

  test(
      'should throws UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpSuccess({'invalid_key': 'invalid_value'});

    final future = sut.auth(params: params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
