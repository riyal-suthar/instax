import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/post/reply_comment_repository.dart';

class PutLikeOnThisReplyUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreReplyOnCommentRepository _replyOnCommentRepository;

  PutLikeOnThisReplyUseCase(this._replyOnCommentRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) =>
      _replyOnCommentRepository.putLikeOnThisReply(
          replyId: paramsOne, myPersonalId: paramsTwo);
}
