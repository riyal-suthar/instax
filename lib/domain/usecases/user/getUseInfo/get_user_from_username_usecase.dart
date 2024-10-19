import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetUserFromUserNameUseCase implements UseCase<UserPersonalInfo?, String> {
  final FireStoreUserRepository _userRepository;

  GetUserFromUserNameUseCase(this._userRepository);

  @override
  Future<UserPersonalInfo?> call({required String params}) =>
      _userRepository.getUserFromUserName(userName: params);
}
