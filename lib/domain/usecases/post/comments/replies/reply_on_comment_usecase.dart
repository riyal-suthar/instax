import 'package:instax/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instax/domain/repositories/post/reply_comment_repository.dart';

import '../../../../../core/use_cases/use_case.dart';

class ReplyOnThisCommentUseCase implements UseCase<Comment, Comment> {
  final FirestoreReplyOnCommentRepository _replyOnCommentRepository;

  ReplyOnThisCommentUseCase(this._replyOnCommentRepository);

  @override
  Future<Comment> call({required Comment params}) =>
      _replyOnCommentRepository.replyOnThisComment(replyInfo: params);
}
