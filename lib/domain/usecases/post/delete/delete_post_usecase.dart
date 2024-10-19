import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/child_classes/post/post.dart';
import 'package:instax/domain/repositories/post/post_repository.dart';

class DeletePostUseCase implements UseCase<void, Post> {
  final FireStorePostRepository _postRepository;

  DeletePostUseCase(this._postRepository);

  @override
  Future<void> call({required Post params}) =>
      _postRepository.deletePost(postInfo: params);
}
