import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyLoginOtpUseCase {
  final AuthRepository repository;

  VerifyLoginOtpUseCase(this.repository);

  Future<User> execute(String challengeId, String otp) {
    return repository.verifyLoginOtp(challengeId, otp);
  }
}
