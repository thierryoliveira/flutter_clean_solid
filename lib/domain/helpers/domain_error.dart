import 'package:flutter_clean_solid/data/http/http.dart';

enum DomainError {
  unexpected,
  invalidCredentials;

  static DomainError throwFromHttpError(HttpError httpError) {
    switch (httpError) {
      case HttpError.unauthorized:
        return DomainError.invalidCredentials;
      default:
        return DomainError.unexpected;
    }
  }
}
