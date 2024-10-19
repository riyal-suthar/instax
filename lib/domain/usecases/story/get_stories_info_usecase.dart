import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/child_classes/post/story.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

import '../../repositories/post/story_repository.dart';

class GetStoriesUseCase
    implements UseCase<List<UserPersonalInfo>, List<dynamic>> {
  final FireStoreStoryRepository _storyRepository;

  GetStoriesUseCase(this._storyRepository);

  @override
  Future<List<UserPersonalInfo>> call({required List<dynamic> params}) =>
      _storyRepository.getStoriesInfo(userIds: params);
}
