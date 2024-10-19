import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/domain/usecases/post/comments/replies/get_replies_on_comment.dart';

import '../../../../../data/models/parent_classes/without_sub_classes/comment.dart';
import '../../../../../domain/usecases/post/comments/replies/reply_on_comment_usecase.dart';

part 'reply_info_state.dart';

class ReplyInfoCubit extends Cubit<ReplyInfoState> {
  final GetRepliesOnThisCommentUseCase _getReplyOnThisComment;
  final ReplyOnThisCommentUseCase _addReplyOnThisCommentUseCase;
  ReplyInfoCubit(
      this._getReplyOnThisComment, this._addReplyOnThisCommentUseCase)
      : super(ReplyInfoInitial());

  List<Comment> repliesOnComment = [];

  static ReplyInfoCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getRepliesOfThisComment({required String commentId}) async {
    emit(ReplyInfoLoading());
    await _getReplyOnThisComment.call(params: commentId).then((value) {
      repliesOnComment = value;
      emit(ReplyInfoLoaded(value));
    }).catchError((e) {
      emit(ReplyInfoFailure(e));
    });
  }

  Future<void> replyOnThisComment({required Comment replyInfo}) async {
    emit(ReplyInfoLoading());
    await _addReplyOnThisCommentUseCase.call(params: replyInfo).then((value) {
      repliesOnComment = repliesOnComment + [value];
      emit(ReplyInfoLoaded(repliesOnComment));
    }).catchError((e) {
      emit(ReplyInfoFailure(e));
    });
  }
}
