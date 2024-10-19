import 'package:instax/core/use_cases/use_case.dart';

import '../../../repositories/post/post_repository.dart';

class PutLikeOnThisPostUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStorePostRepository _postRepository;

  PutLikeOnThisPostUseCase(this._postRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) =>
      _postRepository.putLikeOnThisPost(postId: paramsOne, userId: paramsTwo);
}
