import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class AddNewUserUseCase implements UseCase<void, UserPersonalInfo> {
  final FireStoreUserRepository _userRepository;

  AddNewUserUseCase(this._userRepository);
  @override
  Future<void> call({required UserPersonalInfo params}) =>
      _userRepository.addNewUser(params);
}
