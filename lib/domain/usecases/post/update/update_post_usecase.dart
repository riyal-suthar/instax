import 'package:instax/core/use_cases/use_case.dart';

import '../../../../data/models/child_classes/post/post.dart';
import '../../../repositories/post/post_repository.dart';

class UpdatePostUseCase implements UseCase<Post, Post> {
  final FireStorePostRepository _postRepository;

  UpdatePostUseCase(this._postRepository);

  @override
  Future<Post> call({required params}) =>
      _postRepository.updatePost(postInfo: params);
}
