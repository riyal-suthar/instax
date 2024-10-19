import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:meta/meta.dart';

import '../../../data/models/child_classes/post/post.dart';
import '../../../domain/usecases/user/add_post_to_user_usecase.dart';
import '../../../domain/usecases/user/getUseInfo/get_all_unfollowers_usecase.dart';
import '../../../domain/usecases/user/getUseInfo/get_user_from_username_usecase.dart';
import '../../../domain/usecases/user/getUseInfo/get_user_info_usecase.dart';
import '../../../domain/usecases/user/update_user_info_usecase.dart';
import '../../../domain/usecases/user/upload_profile_image_usecase.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetUserInfoUseCase _getUserInfoUseCase;
  final GetAllUnFollowersUsersUseCase _allUnFollowersUsersUseCase;
  final UpdateUserInfoUseCase _updateUserInfoUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final AddPostToUserUseCase _addPostToUserUseCase;
  final GetUserFromUserNameUseCase _getUserFromUserNameUseCase;

  UserInfoCubit(
      this._getUserInfoUseCase,
      this._allUnFollowersUsersUseCase,
      this._updateUserInfoUseCase,
      this._uploadProfileImageUseCase,
      this._addPostToUserUseCase,
      this._getUserFromUserNameUseCase)
      : super(UserInfoInitial());

  late UserPersonalInfo myPersonalInfo;

  static UserInfoCubit get(BuildContext context) =>
      BlocProvider.of<UserInfoCubit>(context);

  static UserPersonalInfo getMyPersonalInfo(BuildContext context) =>
      BlocProvider.of<UserInfoCubit>(context).myPersonalInfo;

  Future<void> getUserInfo(String userId,
      {bool isThatMyPersonalId = true, bool getDeviceToken = false}) async {
    emit(UserLoading());
    await _getUserInfoUseCase
        .call(paramsOne: userId, paramsTwo: isThatMyPersonalId)
        .then((value) {
      if (isThatMyPersonalId) {
        myPersonalInfo = value;
        emit(CubitMyPersonalInfoLoaded(value));
      } else {
        emit(UserLoaded(value));
      }
    }).catchError((e) {
      emit(GetUserInfoFailed(e));
    });
  }

  Future<void> getAllUnFollowersUsers(UserPersonalInfo myPersonalInfo) async {
    emit(AllUnFollowersUserLoading());
    await _allUnFollowersUsersUseCase
        .call(params: myPersonalInfo)
        .then((value) {
      emit(AllUnFollowersUserLoaded(value));
    }).catchError((e) {
      emit(GetUserInfoFailed(e.toString()));
    });
  }

  void updateMyFollowings({required dynamic userId, bool addThisUser = true}) {
    if (addThisUser) {
      myPersonalInfo.followedPeople.add(userId);
    } else {
      myPersonalInfo.followedPeople.remove(userId);
    }
    emit(CubitMyPersonalInfoLoaded(myPersonalInfo));
  }

  void updateMyStories({required String storyId}) async {
    emit(UserLoading());
    myPersonalInfo.stories.add(storyId);
    emit(CubitMyPersonalInfoLoaded(myPersonalInfo));
  }

  Future<void> getUserFromUserName(String username) async {
    emit(UserLoading());
    await _getUserFromUserNameUseCase.call(params: username).then((value) {
      if (value != null) {
        if (myPersonalInfo.userName == value) {
          emit(CubitMyPersonalInfoLoaded(value));
        } else {
          emit(UserLoaded(value));
        }
      } else {
        emit(GetUserInfoFailed(""));
      }
    }).catchError((e) {
      emit(GetUserInfoFailed(e));
    });
  }

  Future<void> uploadProfileImage(
      {required Uint8List photo,
      required String userId,
      required String previousImageUrl}) async {
    emit(UserLoading());
    await _uploadProfileImageUseCase
        .call(
            paramsOne: photo, paramsTwo: userId, paramsThree: previousImageUrl)
        .then((value) {
      myPersonalInfo.profileImageUrl = value;
      emit(CubitMyPersonalInfoLoaded(myPersonalInfo));
    }).catchError((e) {
      emit(GetUserInfoFailed(e));
    });
  }

  Future<void> updateUserInfo(UserPersonalInfo updatedUserInfo) async {
    emit(UserLoading());
    await _updateUserInfoUseCase.call(params: updatedUserInfo).then((value) {
      myPersonalInfo = value;
      emit(CubitMyPersonalInfoLoaded(myPersonalInfo));
    }).catchError((e) {
      emit(GetUserInfoFailed(e));
    });
  }

  Future<void> updatePostInfo(
      {required String userId, required Post postInfo}) async {
    emit(UserLoading());
    await _addPostToUserUseCase
        .call(paramsOne: userId, paramsTwo: postInfo)
        .then((value) {
      myPersonalInfo = value;
      emit(CubitMyPersonalInfoLoaded(value));
    }).catchError((e) {
      emit(GetUserInfoFailed(e));
    });
  }
}
