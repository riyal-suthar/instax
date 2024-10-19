import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/auth_repository.dart';

class SignOutUseCase implements UseCase<void, String> {
  final FirebaseAuthRepository _authRepo;

  SignOutUseCase(this._authRepo);

  @override
  Future<void> call({required String params}) {
    return _authRepo.signOut(userId: params);
  }
}
