import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/parent_classes/without_sub_classes/comment.dart';
import '../../../../domain/usecases/post/comments/add_comment_usecase.dart';
import '../../../../domain/usecases/post/comments/getComments/get_specific_comments_usecase.dart';

part 'comments_info_state.dart';

class CommentsInfoCubit extends Cubit<CommentsInfoState> {
  final GetSpecificCommentsUseCase _getSpecificCommentsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  CommentsInfoCubit(this._getSpecificCommentsUseCase, this._addCommentUseCase)
      : super(CommentsInfoInitial());

  static CommentsInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  List<Comment> commentsOfPost = [];

  Future<void> getSpecificComments({required String postId}) async {
    emit(CommentsInfoLoading());
    await _getSpecificCommentsUseCase.call(params: postId).then((value) {
      commentsOfPost = value;
      emit(CommentsInfoLoaded(value));
    }).catchError((e) {
      emit(CommentsInfoFailed(e));
    });
  }

  Future<void> addComment({required Comment commentInfo}) async {
    emit(CommentsInfoLoading());
    await _addCommentUseCase.call(params: commentInfo).then((value) {
      commentsOfPost = commentsOfPost + [value];
      emit(CommentsInfoLoaded(commentsOfPost));
    }).catchError((e) {
      emit(CommentsInfoFailed(e));
    });
  }
}
