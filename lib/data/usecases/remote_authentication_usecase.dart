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
    final body = params.toJson();
    await httpClient.request(url: url, method: 'post', body: body);
  }
}
