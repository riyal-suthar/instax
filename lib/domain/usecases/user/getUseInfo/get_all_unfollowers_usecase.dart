import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetAllUnFollowersUsersUseCase
    implements UseCase<List<UserPersonalInfo>, UserPersonalInfo> {
  final FireStoreUserRepository _userRepository;

  GetAllUnFollowersUsersUseCase(this._userRepository);

  @override
  Future<List<UserPersonalInfo>> call({required UserPersonalInfo params}) =>
      _userRepository.getAllUnfollowersUsers(params);
}
