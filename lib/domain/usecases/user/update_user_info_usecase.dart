import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class UpdateUserInfoUseCase
    implements UseCase<UserPersonalInfo, UserPersonalInfo> {
  final FireStoreUserRepository _userRepository;
  UpdateUserInfoUseCase(this._userRepository);

  @override
  Future<UserPersonalInfo> call({required UserPersonalInfo params}) =>
      _userRepository.updateUserInfo(userInfo: params);
}
