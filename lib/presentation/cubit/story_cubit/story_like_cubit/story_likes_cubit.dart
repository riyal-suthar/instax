import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/story/likes/put_like_on_story_usecase.dart';
import '../../../../domain/usecases/story/likes/remove_like_on_story_usecase.dart';

part 'story_likes_state.dart';

class StoryLikesCubit extends Cubit<StoryLikesState> {
  final PutLikeOnThisStoryUseCase _putLikeOnThisStoryUseCase;
  final RemoveLikeOnThisStoryUseCase _removeLikeOnThisStoryUseCase;
  StoryLikesCubit(
      this._putLikeOnThisStoryUseCase, this._removeLikeOnThisStoryUseCase)
      : super(StoryLikesInitial());

  static StoryLikesCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> putLikeOnThisStory(
      {required String storyId, required String userId}) async {
    emit(StoryLikesLoading());
    await _putLikeOnThisStoryUseCase
        .call(paramsOne: storyId, paramsTwo: userId)
        .then((value) {
      emit(StoryLikesLoaded());
    }).catchError((e) {
      emit(StoryLikesFailed(e));
    });
  }

  Future<void> removeLikeOnThisStory(
      {required String storyId, required String userId}) async {
    emit(StoryLikesLoading());
    await _removeLikeOnThisStoryUseCase
        .call(paramsOne: storyId, paramsTwo: userId)
        .then((value) {
      emit(StoryLikesLoaded());
    }).catchError((e) {
      emit(StoryLikesFailed(e));
    });
  }
}
