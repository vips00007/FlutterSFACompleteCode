import '../repositories/auth_repository.dart';
import '../../data/models/forgot_password_response.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<VerifyOtpData> execute(String identifier, String otp) {
    return repository.verifyOtp(identifier, otp);
  }
}
