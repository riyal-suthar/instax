import 'package:instax/data/data_sources/remote/fiirebase_firestore/post/comment/firestore_reply_comment.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instax/domain/repositories/post/reply_comment_repository.dart';

import '../../../../../core/use_cases/use_case.dart';

class GetRepliesOnThisCommentUseCase implements UseCase<List<Comment>, String> {
  final FirestoreReplyOnCommentRepository _replyComment;

  GetRepliesOnThisCommentUseCase(this._replyComment);
  @override
  Future<List<Comment>> call({required String params}) =>
      _replyComment.getSpecificReplies(commentId: params);
}
