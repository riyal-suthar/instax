import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetAllUsersUseCase
    implements StreamUseCase<List<UserPersonalInfo>, void> {
  final FireStoreUserRepository _userRepository;

  GetAllUsersUseCase(this._userRepository);

  @override
  Stream<List<UserPersonalInfo>> call({required void params}) =>
      _userRepository.getAllUsers();
}
