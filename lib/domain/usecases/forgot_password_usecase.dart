import '../repositories/auth_repository.dart';
import '../../data/models/forgot_password_response.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<ForgotPasswordData> execute(String identifier) {
    return repository.requestPasswordReset(identifier);
  }
}
