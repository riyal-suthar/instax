import 'package:instax/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instax/domain/repositories/post/comment_repository.dart';

import '../../../../../core/use_cases/use_case.dart';

class GetSpecificCommentsUseCase implements UseCase<List<Comment>, String> {
  final FirestoreCommentRepository _commentRepository;

  GetSpecificCommentsUseCase(this._commentRepository);

  @override
  Future<List<Comment>> call({required String params}) =>
      _commentRepository.getSpecificComments(postId: params);
}
