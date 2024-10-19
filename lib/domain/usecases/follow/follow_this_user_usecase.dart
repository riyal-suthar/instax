import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class FollowThisUserUseCase implements UseCaseTwoParams<void, String, String> {
  final FireStoreUserRepository _userRepository;

  FollowThisUserUseCase(this._userRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _userRepository.followThisUser(paramsOne, paramsTwo);
  }
}
