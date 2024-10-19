import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/usecases/post/comments/put_like_on_comment.dart';
import '../../../../../domain/usecases/post/comments/remove_like_on_comment.dart';

part 'comment_likes_state.dart';

class CommentLikesCubit extends Cubit<CommentLikesState> {
  final PutLikeOnThisCommentUseCase _putLikeOnThisCommentUseCase;
  final RemoveLikeOnThisCommentUseCase _removeLikeOnThisCommentUseCase;
  CommentLikesCubit(
      this._putLikeOnThisCommentUseCase, this._removeLikeOnThisCommentUseCase)
      : super(CommentLikesInitial());

  static CommentLikesCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> putLikeOnThisComment(
      {required String postId,
      required String commentId,
      required String myPersonalId}) async {
    emit(CommentLikesLoading());
    await _putLikeOnThisCommentUseCase
        .call(paramsOne: commentId, paramsTwo: myPersonalId)
        .then((value) {
      emit(CommentLikesLoaded());
    }).catchError((e) {
      emit(CommentLikesFailed(e));
    });
  }

  Future<void> removeLikeOnThisComment(
      {required String postId,
      required String commentId,
      required String myPersonalId}) async {
    emit(CommentLikesLoading());
    await _removeLikeOnThisCommentUseCase
        .call(paramsOne: commentId, paramsTwo: myPersonalId)
        .then((value) {
      emit(CommentLikesLoaded());
    }).catchError((e) {
      emit(CommentLikesFailed(e));
    });
  }
}
