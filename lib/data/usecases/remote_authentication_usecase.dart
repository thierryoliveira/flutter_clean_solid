import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthenticationUsecase {
  final HttpClient httpClient;
  final String url;

  RemoteAuthenticationUsecase({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth({required AuthenticationParams params}) async {
    final body = RemoteAuthenticationParams.fromEntity(params).toJson();

    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError catch (httpError) {
      throw DomainError.throwFromHttpError(httpError);
    }
  }
}

class RemoteAuthenticationParams extends AuthenticationParams {
  RemoteAuthenticationParams({required super.email, required super.password});

  factory RemoteAuthenticationParams.fromEntity(AuthenticationParams entity) =>
      RemoteAuthenticationParams(
          email: entity.email, password: entity.password);

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
