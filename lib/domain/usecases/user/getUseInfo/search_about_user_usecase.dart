import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class SearchAboutUserUseCase
    implements StreamUseCaseTwoParams<List<UserPersonalInfo>, String, bool> {
  final FireStoreUserRepository _userRepository;

  SearchAboutUserUseCase(this._userRepository);

  @override
  Stream<List<UserPersonalInfo>> call(
      {required String paramsOne, required bool paramsTwo}) {
    return _userRepository.searchAboutUser(
        name: paramsOne, searchForSingleLetter: paramsTwo);
  }
}
