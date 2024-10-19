import 'dart:io';
import 'dart:typed_data';

// import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/post/post_repository.dart';

import '../../../data/models/child_classes/post/post.dart';

class CreatePostUseCase
    implements UseCaseThreeParams<Post, Post, List<SelectedByte>, Uint8List?> {
  final FireStorePostRepository _postRepository;

  CreatePostUseCase(this._postRepository);

  @override
  Future<Post> call(
          {required Post paramsOne,
          required List<SelectedByte> paramsTwo,
          required Uint8List? paramsThree}) =>
      _postRepository.createPost(
          postInfo: paramsOne, files: paramsTwo, coverOfVideo: paramsThree);
}
