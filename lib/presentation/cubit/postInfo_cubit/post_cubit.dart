import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instax/domain/usecases/post/get/get_post_info_usecase.dart';
import 'package:meta/meta.dart';

import '../../../data/models/child_classes/post/post.dart';
import '../../../domain/usecases/post/create_post_usecase.dart';
import '../../../domain/usecases/post/delete/delete_post_usecase.dart';
import '../../../domain/usecases/post/get/get_all_posts_usecase.dart';
import '../../../domain/usecases/post/update/update_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUseCase _createPostUseCase;
  final GetPostsInfoUseCase _getPostsInfoUseCase;
  final GetAllPostsUseCase _allPostsUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  PostCubit(this._createPostUseCase, this._getPostsInfoUseCase,
      this._allPostsUseCase, this._updatePostUseCase, this._deletePostUseCase)
      : super(PostInitial());

  Post? newPostInfo;
  List<Post>? myPostsInfo;
  List<Post>? userPostsInfo;
  List<Post>? allPostsInfo;

  static PostCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> createPost(Post postInfo, List<SelectedByte> files,
      {Uint8List? coverOfVideo}) async {
    emit(PostLoading());
    await _createPostUseCase
        .call(paramsOne: postInfo, paramsTwo: files, paramsThree: coverOfVideo)
        .then((value) {
      newPostInfo = value;
      emit(PostLoaded(value));
    }).catchError((e) {
      emit(PostFailed(e));
    });
  }

  Future<void> getPostsInfo(
      {required List<dynamic> postIds,
      required bool isThatMyPosts,
      int lengthOfCurrentList = -1}) async {
    emit(PostLoading());
    await _getPostsInfoUseCase
        .call(paramsOne: postIds, paramsTwo: lengthOfCurrentList)
        .then((value) {
      if (isThatMyPosts) {
        myPostsInfo = value;
        emit(MyPersonalPostsLoaded(value));
      } else {
        userPostsInfo = value;
        emit(PostsInfoLoaded(value));
      }
    }).catchError((e) {
      emit(PostFailed(e.toString()));
    });
  }

  Future<void> getAllPostsInfo(
      {bool isVideosWantedOnly = false, String skippedVideoUid = ""}) async {
    emit(PostLoading());
    await _allPostsUseCase
        .call(paramsOne: isVideosWantedOnly, paramsTwo: skippedVideoUid)
        .then((value) {
      allPostsInfo = value;
      emit(AllPostsLoaded(value));
    }).catchError((e) {
      emit(PostFailed(e));
    });
  }

  Future<void> updatePostInfo({required Post postInfo}) async {
    emit(PostLoading());
    await _updatePostUseCase.call(params: postInfo).then((value) {
      if (myPostsInfo != null) {
        int index = myPostsInfo!.indexOf(postInfo);
        myPostsInfo![index] = value;
        emit(MyPersonalPostsLoaded(myPostsInfo!));
      }
      emit(UpdatePostLoaded(value));
    }).catchError((e) {
      emit(PostFailed(e));
    });
  }

  Future<void> deletePost({required Post postInfo}) async {
    emit(DeletePostLoading());
    await _deletePostUseCase.call(params: postInfo).then((value) {
      if (myPostsInfo != null) {
        myPostsInfo!
            .removeWhere((element) => element.postUid == postInfo.postUid);
        emit(MyPersonalPostsLoaded(myPostsInfo!));
      }
      emit(DeletePostLoaded());
    }).catchError((e) {
      emit(PostFailed(e));
    });
  }
}
