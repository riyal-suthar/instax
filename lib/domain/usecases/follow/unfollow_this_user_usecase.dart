import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class UnFollowThisUserUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStoreUserRepository _userRepository;

  UnFollowThisUserUseCase(this._userRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _userRepository.unFollowThisUser(paramsOne, paramsTwo);
  }
}
