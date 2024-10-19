import '../../../../core/use_cases/use_case.dart';
import '../../../repositories/post/story_repository.dart';

class PutLikeOnThisStoryUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStoreStoryRepository _storyRepository;

  PutLikeOnThisStoryUseCase(this._storyRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) =>
      _storyRepository.putLikeOnThisStory(
          storyId: paramsOne, userId: paramsTwo);
}
