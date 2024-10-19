import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/entities/specific_user_info.dart';

import '../../../repositories/user_repository.dart';

class GetFollowersAndFollowingsUseCase
    implements
        UseCaseTwoParams<FollowersAndFollowingsInfo, List<dynamic>,
            List<dynamic>> {
  final FireStoreUserRepository _userRepository;

  GetFollowersAndFollowingsUseCase(this._userRepository);

  @override
  Future<FollowersAndFollowingsInfo> call(
          {required List paramsOne, required List paramsTwo}) =>
      _userRepository.getFollowersAndFollowingsInfo(
          followersIds: paramsOne, followingsIds: paramsTwo);
}
