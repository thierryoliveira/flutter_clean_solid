import 'package:flutter_clean_solid/data/models/models.dart';
import 'package:flutter_clean_solid/domain/entities/entities.dart';
import 'package:flutter_clean_solid/infra/http/http.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthenticationUsecase implements AuthenticationUseCase {
  final HttpClient httpClient;
  final String url;

  RemoteAuthenticationUsecase({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> auth({required AuthenticationParams params}) async {
    final body = RemoteAuthenticationParams.fromEntity(params).toJson();

    try {
      final response = await httpClient.request(
          url: url, method: HttpMethods.post, body: body);
      return RemoteAccountModel.fromJson(response).toEntity();
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
