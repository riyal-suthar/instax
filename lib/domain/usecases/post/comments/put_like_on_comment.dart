import 'package:instax/domain/repositories/post/comment_repository.dart';

import '../../../../core/use_cases/use_case.dart';

class PutLikeOnThisCommentUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreCommentRepository _commentRepository;

  PutLikeOnThisCommentUseCase(this._commentRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) =>
      _commentRepository.putLikeOnThisComment(
          commentId: paramsOne, myPersonalId: paramsTwo);
}
