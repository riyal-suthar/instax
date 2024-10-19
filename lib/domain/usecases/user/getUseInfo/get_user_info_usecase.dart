import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetUserInfoUseCase
    implements UseCaseTwoParams<UserPersonalInfo, String, bool> {
  final FireStoreUserRepository _userRepository;

  GetUserInfoUseCase(this._userRepository);

  @override
  Future<UserPersonalInfo> call(
          {required String paramsOne, required bool paramsTwo}) =>
      _userRepository.getPersonalInfo(
          userId: paramsOne, getDeviceToken: paramsTwo);
}
