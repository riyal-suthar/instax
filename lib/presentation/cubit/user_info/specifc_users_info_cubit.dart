import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/domain/entities/specific_user_info.dart';
import 'package:meta/meta.dart';

import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../domain/entities/sender_receiver_info.dart';
import '../../../domain/usecases/message/commen/get_chats_users_info.dart';
import '../../../domain/usecases/user/getUseInfo/get_followers_following_usecase.dart';
import '../../../domain/usecases/user/getUseInfo/get_specific_users_usecase.dart';

part 'specifc_users_info_state.dart';

class SpecificUsersInfoCubit extends Cubit<SpecificUsersInfoState> {
  final GetFollowersAndFollowingsUseCase _followersAndFollowingsUseCase;
  final GetSpecificUsersUseCase _getSpecificUsersInfoUseCase;
  final GetChatUsersInfoAddMessageUseCase _chatUsersInfoAddMessageUseCase;
  SpecificUsersInfoCubit(this._followersAndFollowingsUseCase,
      this._getSpecificUsersInfoUseCase, this._chatUsersInfoAddMessageUseCase)
      : super(SpecifcUsersInfoInitial());

  static SpecificUsersInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds}) async {
    emit(FollowersAndFollowingsLoading());
    await _followersAndFollowingsUseCase
        .call(paramsOne: followersIds, paramsTwo: followingsIds)
        .then((value) {
      emit(FollowersAndFollowingsLoaded(value));
    }).catchError((e) {
      emit(SpecificUsersFailed(e));
    });
  }

  Future<void> getSpecificUsersInfo({required List<dynamic> usersIds}) async {
    emit(FollowersAndFollowingsLoading());
    await _getSpecificUsersInfoUseCase.call(params: usersIds).then((value) {
      emit(SpecificUsersLoaded(value));
    }).catchError((e) {
      emit(SpecificUsersFailed(e));
    });
  }

  Future<void> getChatUsersInfo(
      {required UserPersonalInfo myPersonalInfo}) async {
    emit(FollowersAndFollowingsLoading());
    await _chatUsersInfoAddMessageUseCase
        .call(params: myPersonalInfo)
        .then((value) {
      emit(GetChatUsersInfoLoaded(value));
    }).catchError((e) {
      emit(SpecificUsersFailed(e.toString()));
    });
  }
}
