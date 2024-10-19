import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/auth_repository.dart';

class EmailVerificationUseCase implements UseCase<bool, String> {
  final FirebaseAuthRepository _authRepo;

  EmailVerificationUseCase(this._authRepo);

  @override
  Future<bool> call({required String params}) {
    return _authRepo.isThisEmailToken(email: params);
  }
}
