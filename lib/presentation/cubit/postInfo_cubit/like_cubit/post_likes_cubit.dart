import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/post/likes/put_like_on_post_usecase.dart';
import '../../../../domain/usecases/post/likes/remove_like_on_post.dart';

part 'post_likes_state.dart';

class PostLikesCubit extends Cubit<PostLikesState> {
  final PutLikeOnThisPostUseCase _putLikeOnThisPostUseCase;
  final RemoveLikeOnThisPostUseCase _removeLikeOnThisPostUseCase;
  PostLikesCubit(
      this._putLikeOnThisPostUseCase, this._removeLikeOnThisPostUseCase)
      : super(PostLikesInitial());

  static PostLikesCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> putLikeOnThisPost(
      {required String postId, required String userId}) async {
    emit(PostLikesLoading());
    await _putLikeOnThisPostUseCase
        .call(paramsOne: postId, paramsTwo: userId)
        .then((value) {
      emit(PostLikesLoaded());
    }).catchError((e) {
      emit(PostLikesFailed(e));
    });
  }

  Future<void> removeLikeOnThisPost(
      {required String postId, required String userId}) async {
    emit(PostLikesLoading());
    await _removeLikeOnThisPostUseCase
        .call(paramsOne: postId, paramsTwo: userId)
        .then((value) {
      emit(PostLikesLoaded());
    }).catchError((e) {
      emit(PostLikesFailed(e));
    });
  }
}
