import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/post/comment_repository.dart';

class RemoveLikeOnThisCommentUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FirestoreCommentRepository _commentRepository;

  RemoveLikeOnThisCommentUseCase(this._commentRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) =>
      _commentRepository.removeLikeOnThisComment(
          commentId: paramsOne, myPersonalId: paramsTwo);
}
