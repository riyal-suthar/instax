import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/domain/usecases/follow/unfollow_this_user_usecase.dart';

import '../../../domain/usecases/follow/follow_this_user_usecase.dart';

part 'follow_un_follow_state.dart';

class FollowUnFollowCubit extends Cubit<FollowUnFollowState> {
  FollowThisUserUseCase _followThisUserUseCase;
  UnFollowThisUserUseCase _unFollowThisUserUseCase;
  FollowUnFollowCubit(
      this._followThisUserUseCase, this._unFollowThisUserUseCase)
      : super(FollowUnFollowInitial());

  static FollowUnFollowCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> followThisUser(
      {required String followingUserId, required String myPersonalId}) async {
    try {
      emit(FollowThisUserLoading());
      await _followThisUserUseCase
          .call(paramsOne: followingUserId, paramsTwo: myPersonalId)
          .then((value) => emit(FollowThisUserLoaded()))
          .catchError((e) => emit(FollowThisUserFailed(e.toString())));
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> unFollowThisUser(
      {required String followingUserId, required String myPersonalId}) async {
    emit(FollowThisUserLoading());
    await _unFollowThisUserUseCase
        .call(paramsOne: followingUserId, paramsTwo: myPersonalId)
        .then((_) {
      emit(FollowThisUserLoaded());
    }).catchError((e) {
      emit(FollowThisUserFailed(e.toString()));
    });
  }
}
