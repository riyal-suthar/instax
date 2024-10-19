import 'package:instax/core/use_cases/use_case.dart';

import '../../../repositories/post/post_repository.dart';

class RemoveLikeOnThisPostUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStorePostRepository _postRepository;

  RemoveLikeOnThisPostUseCase(this._postRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) =>
      _postRepository.removeTheLikeOnThisPost(
          postId: paramsOne, userId: paramsTwo);
}
