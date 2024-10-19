import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/post/story_repository.dart';

class DeleteStoryUseCase implements UseCase<void, String> {
  final FireStoreStoryRepository _storyRepository;

  DeleteStoryUseCase(this._storyRepository);

  @override
  Future<void> call({required String params}) =>
      _storyRepository.deleteThisStory(storyId: params);
}
