import '../entities/entities.dart';

abstract class AuthenticationUseCase {
  Future<AccountEntity> auth({required String email, required String password});
}
