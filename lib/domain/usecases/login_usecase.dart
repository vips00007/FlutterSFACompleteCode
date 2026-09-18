import '../../data/models/sfa_otp_models.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<SendLoginOtpData> execute(String identifier) {
    return repository.sendLoginOtp(identifier);
  }
}
