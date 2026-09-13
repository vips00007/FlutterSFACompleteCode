import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyLoginOtpUseCase {
  final AuthRepository repository;

  VerifyLoginOtpUseCase(this.repository);

  Future<User> execute(String phone, String otp) {
    return repository.verifyLoginOtp(phone, otp);
  }
}
