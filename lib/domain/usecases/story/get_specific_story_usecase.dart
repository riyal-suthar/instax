import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

import '../../../core/use_cases/use_case.dart';
import '../../repositories/post/story_repository.dart';

class GetSpecificStoriesUseCase
    implements UseCase<UserPersonalInfo, UserPersonalInfo> {
  final FireStoreStoryRepository _storyRepository;

  GetSpecificStoriesUseCase(this._storyRepository);

  @override
  Future<UserPersonalInfo> call({required UserPersonalInfo params}) =>
      _storyRepository.getSpecificStoriesInfo(userInfo: params);
}
