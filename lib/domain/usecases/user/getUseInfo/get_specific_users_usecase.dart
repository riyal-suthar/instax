import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetSpecificUsersUseCase
    implements UseCase<List<UserPersonalInfo>, List<dynamic>> {
  final FireStoreUserRepository _userRepository;

  GetSpecificUsersUseCase(this._userRepository);

  @override
  Future<List<UserPersonalInfo>> call({required List<dynamic> params}) =>
      _userRepository.getSpecificUsersInfo(usersIds: params);
}
