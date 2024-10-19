import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/post/post_repository.dart';

import '../../../../data/models/child_classes/post/post.dart';

class GetAllPostsUseCase implements UseCaseTwoParams<List<Post>, bool, String> {
  final FireStorePostRepository _postRepository;

  GetAllPostsUseCase(this._postRepository);

  @override
  Future<List<Post>> call(
          {required bool paramsOne, required String paramsTwo}) =>
      _postRepository.getAllPostsInfo(
          isVideosWantedOnly: paramsOne, skippedVideoUid: paramsTwo);
}
