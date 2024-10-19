import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/post/reply_comment_repository.dart';

class RemoveLikeOnThisReplyUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreReplyOnCommentRepository _replyOnCommentRepository;

  RemoveLikeOnThisReplyUseCase(this._replyOnCommentRepository);
  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) =>
      _replyOnCommentRepository.removeLikeOnThisReply(
          replyId: paramsOne, myPersonalId: paramsTwo);
}
