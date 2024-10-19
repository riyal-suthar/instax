import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/child_classes/post/story.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../domain/usecases/story/create_story_usecase.dart';
import '../../../domain/usecases/story/delete/delete_story_usecase.dart';
import '../../../domain/usecases/story/get_specific_story_usecase.dart';
import '../../../domain/usecases/story/get_stories_info_usecase.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final CreateStoryUseCase _createStoryUseCase;
  final GetStoriesUseCase _getStoriesInfoUseCase;
  final GetSpecificStoriesUseCase _getSpecificStoriesInfoUseCase;
  final DeleteStoryUseCase _deleteStoryUseCase;
  String storyId = "";
  StoryCubit(this._createStoryUseCase, this._getStoriesInfoUseCase,
      this._getSpecificStoriesInfoUseCase, this._deleteStoryUseCase)
      : super(StoryInitial());

  static StoryCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> createStory(Story storyInfo, Uint8List file) async {
    emit(StoryLoading());
    await _createStoryUseCase
        .call(paramsOne: storyInfo, paramsTwo: file)
        .then((value) {
      storyId = value;
      emit(StoryLoaded(value));
      return storyId;
    }).catchError((e) {
      emit(StoryFailed(e.toString()));
      return "Cubit story failed";
    });
  }

  Future<void> getStoriesInfo(
      {required List<dynamic> usersIds,
      required UserPersonalInfo myPersonalInfo}) async {
    if (!usersIds.contains(myPersonalInfo.userId)) {
      usersIds = [myPersonalInfo.userId] + usersIds;
    }

    emit(StoryLoading());
    await _getStoriesInfoUseCase.call(params: usersIds).then((value) {
      emit(StoriesInfoLoaded(value));
    }).catchError((e) {
      emit(StoryFailed(e.toString()));
    });
  }

  Future<void> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo}) async {
    emit(StoryLoading());
    await _getSpecificStoriesInfoUseCase.call(params: userInfo).then((value) {
      emit(SpecificStoriesInfoLoaded(userInfo));
    }).catchError((e) {
      emit(StoryFailed(e.toString()));
    });
  }

  Future<void> deleteStory({required String storyId}) async {
    emit(DeletingStoryLoading());
    await _deleteStoryUseCase.call(params: storyId).then((value) {
      emit(DeletingStoryLoaded());
    }).catchError((e) {
      emit(StoryFailed(e.toString()));
    });
  }
}
