import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetMyInfoUseCase implements StreamUseCase<UserPersonalInfo, void> {
  final FireStoreUserRepository _userRepository;

  GetMyInfoUseCase(this._userRepository);

  @override
  Stream<UserPersonalInfo> call({required void params}) =>
      _userRepository.getMyPersonalInfo();
}
