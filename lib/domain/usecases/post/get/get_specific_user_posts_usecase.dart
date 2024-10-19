import 'package:instax/core/use_cases/use_case.dart';

import '../../../repositories/post/post_repository.dart';

class GetSpecificUsersPostsUseCase
    implements UseCase<List<dynamic>, List<dynamic>> {
  final FireStorePostRepository _postRepository;

  GetSpecificUsersPostsUseCase(this._postRepository);

  @override
  Future<List> call({required List params}) =>
      _postRepository.getSpecificUsersPosts(params);
}
