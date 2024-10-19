import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/child_classes/post/post.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class AddPostToUserUseCase
    implements UseCaseTwoParams<UserPersonalInfo, String, Post> {
  final FireStoreUserRepository _userRepository;

  AddPostToUserUseCase(this._userRepository);
  @override
  Future<UserPersonalInfo> call(
          {required String paramsOne, required Post paramsTwo}) =>
      _userRepository.updateUserPostsInfo(
          userId: paramsOne, postInfo: paramsTwo);
}
