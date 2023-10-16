import 'package:faker/faker.dart';
import 'package:flutter_clean_solid/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RemoteAuthenticationUsecase {
  final HttpClient httpClient;
  final String url;

  RemoteAuthenticationUsecase({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth({required AuthenticationParams params}) async {
    final body = {'email': params.email, 'password': params.password};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthenticationUsecase sut;
  late HttpClient httpClient;
  late String url;
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthenticationUsecase(httpClient: httpClient, url: url);

    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((invocation) => Future.value());
  });

  test('should call HttpClient with the correct URL', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    await sut.auth(params: params);

    verify(() => httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password}));
  });
}
