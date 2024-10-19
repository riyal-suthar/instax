import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/child_classes/post/post.dart';
import 'package:instax/domain/repositories/post/post_repository.dart';

class GetPostsInfoUseCase
    implements UseCaseTwoParams<List<Post>, List<dynamic>, int> {
  final FireStorePostRepository _postRepository;

  GetPostsInfoUseCase(this._postRepository);

  @override
  Future<List<Post>> call({required List paramsOne, required int paramsTwo}) =>
      _postRepository.getPostsInfo(
          postsIds: paramsOne, lengthOfCurrentList: paramsTwo);
}
