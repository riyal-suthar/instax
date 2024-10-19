import '../../../../core/use_cases/use_case.dart';
import '../../../repositories/post/story_repository.dart';

class RemoveLikeOnThisStoryUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStoreStoryRepository _storyRepository;

  RemoveLikeOnThisStoryUseCase(this._storyRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) =>
      _storyRepository.removeTheLikeOnThisStory(
          storyId: paramsOne, userId: paramsTwo);
}
