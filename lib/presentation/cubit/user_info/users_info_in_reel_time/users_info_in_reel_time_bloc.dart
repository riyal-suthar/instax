import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/usecases/user/getUseInfo/get_all_users_usecase.dart';

import '../../../../core/utils/constants.dart';
import '../../../../domain/usecases/user/my_personal_info_usecase.dart';

part 'users_info_in_reel_time_event.dart';
part 'users_info_in_reel_time_state.dart';

class UsersInfoInReelTimeBloc
    extends Bloc<UsersInfoInReelTimeEvent, UsersInfoInReelTimeState> {
  final GetMyInfoUseCase _getMyInfoUseCase;
  final GetAllUsersUseCase _getAllUsersUseCase;
  UsersInfoInReelTimeBloc(this._getMyInfoUseCase, this._getAllUsersUseCase)
      : super(UsersInfoInReelTimeInitial()) {
    on<UsersInfoInReelTimeEvent>((event, emit) async {
      if (event is LoadMyPersonalInfo) {
        await emit.onEach(
          _getMyInfoUseCase.call(params: null),
          onData: (myInfoInReel) => add(UpdateMyPersonalInfo(myInfoInReel)),
          // onError: (e, s) => MyPersonalInfoFailed(e.toString())
        );
      } else if (event is UpdateMyPersonalInfo) {
        myPersonalInfoInReelTime = event.myPersonalInfoInReelTime;
        isMyInfoInReelTimeReady = true;
        return emit(MyPersonalInfoLoaded(
            myPersonalInfoInReelTime: event.myPersonalInfoInReelTime));
      } else if (event is LoadAllUsersInfo) {
        await emit.onEach(
          _getAllUsersUseCase.call(params: null),
          onData: (userInfoInReel) => add(UpdateAllUsersInfo(userInfoInReel)),
          // onError: (e, s) => MyPersonalInfoFailed(e.toString())
        );
      } else if (event is UpdateAllUsersInfo) {
        allUsersInfoInReelTime = event.allUsersInfoInReelTime;
        return emit(AllUsersInfoLoaded(
            allUsersInfoInReelTime: event.allUsersInfoInReelTime));
      }
    });
  }

  UserPersonalInfo? myPersonalInfoInReelTime;
  List<UserPersonalInfo> allUsersInfoInReelTime = [];

  static UsersInfoInReelTimeBloc get(BuildContext context) =>
      BlocProvider.of(context);

  static UserPersonalInfo? getMyInfoInReelTime(BuildContext context) =>
      BlocProvider.of<UsersInfoInReelTimeBloc>(context)
          .myPersonalInfoInReelTime;

  // Stream<UsersInfoInReelTimeState> mapEventToState(
  //     UsersInfoInReelTimeEvent event) async* {
  //   if (event is LoadMyPersonalInfo) {
  //     yield* _mapLoadMyInfoToState();
  //   } else if (event is UpdateMyPersonalInfo) {
  //     yield* _mapUpdateMyInfoToState(event);
  //   }
  //   if (event is LoadAllUsersInfo) {
  //     yield* _mapLoadUsersInfoToState();
  //   } else if (event is UpdateAllUsersInfo) {
  //     yield* _mapUpdateUsersInfoToState(event);
  //   }
  // }
  //
  // Stream<UsersInfoInReelTimeState> _mapLoadMyInfoToState() async* {
  //   _getMyInfoUseCase
  //       .call(params: null)
  //       .listen((event) => add(UpdateMyPersonalInfo(event)))
  //       .onError((e) async* {
  //     yield MyPersonalInfoFailed(e.toString());
  //   });
  // }
  //
  // Stream<UsersInfoInReelTimeState> _mapUpdateMyInfoToState(
  //     UpdateMyPersonalInfo event) async* {
  //   myPersonalInfoInReelTime = event.myPersonalInfoInReelTime;
  //   isMyInfoInReelTimeReady = true;
  //
  //   yield MyPersonalInfoLoaded(
  //       myPersonalInfoInReelTime: event.myPersonalInfoInReelTime);
  // }
  //
  // Stream<UsersInfoInReelTimeState> _mapLoadUsersInfoToState() async* {
  //   _getAllUsersUSeCase
  //       .call(params: null)
  //       .listen((event) => add(UpdateAllUsersInfo(event)))
  //       .onError((e) async* {
  //     yield MyPersonalInfoFailed(e.toString());
  //   });
  // }
  //
  // Stream<UsersInfoInReelTimeState> _mapUpdateUsersInfoToState(
  //     UpdateAllUsersInfo event) async* {
  //   allUsersInfoInReelTime = event.allUsersInfoInReelTime;
  //   yield AllUsersInfoLoaded(
  //       allUsersInfoInReelTime: event.allUsersInfoInReelTime);
  // }
}
