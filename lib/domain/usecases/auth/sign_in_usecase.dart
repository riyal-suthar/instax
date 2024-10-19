import 'package:firebase_auth/firebase_auth.dart';
import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/entities/register_user.dart';
import 'package:instax/domain/entities/sign_in_entity.dart';
import 'package:instax/domain/repositories/auth_repository.dart';

class SignInUseCase implements UseCase<User, RegisteredUser> {
  final FirebaseAuthRepository _authRepo;

  SignInUseCase(this._authRepo);

  @override
  Future<User> call({required RegisteredUser params}) {
    return _authRepo.signIn(params);
  }
}
