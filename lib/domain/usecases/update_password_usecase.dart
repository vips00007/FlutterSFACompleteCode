import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<void> execute(String resetToken, String newPassword) {
    return repository.updatePassword(resetToken, newPassword);
  }
}
