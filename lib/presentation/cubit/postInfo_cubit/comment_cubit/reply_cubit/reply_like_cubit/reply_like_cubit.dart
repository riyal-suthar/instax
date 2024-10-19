import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../domain/usecases/post/comments/replies/likesOnReply/put_like_on_reply_usecase.dart';
import '../../../../../../domain/usecases/post/comments/replies/likesOnReply/remove_like_on_reply_usecase.dart';

part 'reply_like_state.dart';

class ReplyLikeCubit extends Cubit<ReplyLikeState> {
  final PutLikeOnThisReplyUseCase _putLikeOnThisReplyUseCase;
  final RemoveLikeOnThisReplyUseCase _removeLikeOnThisReplyUseCase;
  ReplyLikeCubit(
      this._putLikeOnThisReplyUseCase, this._removeLikeOnThisReplyUseCase)
      : super(ReplyLikeInitial());

  static ReplyLikeCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    emit(ReplyLikeLoading());

    await _putLikeOnThisReplyUseCase
        .call(paramsOne: replyId, paramsTwo: myPersonalId)
        .then((_) {
      emit(ReplyLikeLoaded());
    }).catchError((e) {
      emit(ReplyLikeFailed(e.toString()));
    });
  }

  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    emit(ReplyLikeLoading());

    await _removeLikeOnThisReplyUseCase
        .call(paramsOne: replyId, paramsTwo: myPersonalId)
        .then((_) {
      emit(ReplyLikeLoaded());
    }).catchError((e) {
      emit(ReplyLikeFailed(e.toString()));
    });
  }
}
