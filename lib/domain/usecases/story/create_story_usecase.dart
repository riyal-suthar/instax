import 'dart:typed_data';

import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/post/story_repository.dart';
import 'package:instax/domain/repositories/user_repository.dart';

import '../../../data/models/child_classes/post/story.dart';

class CreateStoryUseCase implements UseCaseTwoParams<String, Story, Uint8List> {
  final FireStoreStoryRepository _storyRepository;

  CreateStoryUseCase(this._storyRepository);

  @override
  Future<String> call(
          {required Story paramsOne, required Uint8List paramsTwo}) =>
      _storyRepository.createStory(storyInfo: paramsOne, file: paramsTwo);
}
