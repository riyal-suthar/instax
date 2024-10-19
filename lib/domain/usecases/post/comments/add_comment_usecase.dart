import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/post/comment_repository.dart';

import '../../../../data/models/parent_classes/without_sub_classes/comment.dart';

class AddCommentUseCase implements UseCase<Comment, Comment> {
  final FirestoreCommentRepository _commentRepository;

  AddCommentUseCase(this._commentRepository);

  @override
  Future<Comment> call({required Comment params}) =>
      _commentRepository.addComment(commentInfo: params);
}
