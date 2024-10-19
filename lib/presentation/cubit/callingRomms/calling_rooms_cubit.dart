import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

import '../../../domain/entities/call_meet.dart';
import '../../../domain/usecases/calling_room/create_calling_room_usecase.dart';
import '../../../domain/usecases/calling_room/delete_room_usecase.dart';
import '../../../domain/usecases/calling_room/get_user_info_in_room.dart';
import '../../../domain/usecases/calling_room/join_to_calling_room_usecase.dart';
import '../../../domain/usecases/calling_room/leave_room_usecase.dart';

part 'calling_rooms_state.dart';

class CallingRoomsCubit extends Cubit<CallingRoomsState> {
  final JoinToCallingRoomUseCase _joinToCallingRoom;
  final CreateCallingRoomUseCase _createCallingRoomUseCase;
  final DeleteTheRoomUseCase _deleteCallingRoomUseCase;
  final CancelJoiningToRoomUseCase _cancelToCallingRoomUseCase;
  final GetUsersInfoInRoomUseCase _getUserInfoInCallingRoomUseCase;
  CallingRoomsCubit(
      this._joinToCallingRoom,
      this._createCallingRoomUseCase,
      this._deleteCallingRoomUseCase,
      this._getUserInfoInCallingRoomUseCase,
      this._cancelToCallingRoomUseCase)
      : super(CallingRoomsInitial());

  static CallingRoomsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required List<UserPersonalInfo> callThoseUser}) async {
    emit(CallingRoomsLoading());
    await _createCallingRoomUseCase
        .call(paramsOne: myPersonalInfo, paramsTwo: callThoseUser)
        .then((value) {
      emit(CallingRoomsLoaded(channelId: value));
    }).catchError((e) {
      emit(CallingRoomsFailed(e));
    });
  }

  Future<void> getUsersInfoInThisRoom({required String channelId}) async {
    emit(CallingRoomsLoading());
    await _getUserInfoInCallingRoomUseCase
        .call(params: channelId)
        .then((value) {
      emit(UsersInfoInRoomLoaded(usersInfo: value));
    }).catchError((e) {
      emit(CallingRoomsFailed(e.toString()));
    });
  }

  Future<void> joinToRoom(
      {required String channelId,
      required UserPersonalInfo myPersonalInfo}) async {
    emit(CallingRoomsLoading());
    await _joinToCallingRoom
        .call(paramsOne: channelId, paramsTwo: myPersonalInfo)
        .then((value) {
      emit(CallingRoomsLoaded(channelId: value));
    }).catchError((e) {
      emit(CallingRoomsFailed(e));
    });
  }

  Future<void> deleteTheRoom(
      {required String channelId, List<dynamic> userIds = const []}) async {
    emit(CallingRoomsLoading());
    await _deleteCallingRoomUseCase
        .call(paramsOne: channelId, paramsTwo: userIds)
        .then((value) {
      emit(const CallingRoomsLoaded(channelId: ""));
    }).catchError((e) {
      emit(CallingRoomsFailed(e));
    });
  }

  Future<void> leaveTheRoom(
      {required String userId,
      required String channelId,
      required bool isThatAfterJoining}) async {
    emit(CallingRoomsLoading());
    await _cancelToCallingRoomUseCase
        .call(
            paramsOne: userId,
            paramsTwo: channelId,
            paramsThree: isThatAfterJoining)
        .then((value) {
      emit(const CallingRoomsLoaded(channelId: ""));
    }).catchError((e) {
      emit(CallingRoomsFailed(e));
    });
  }
}
