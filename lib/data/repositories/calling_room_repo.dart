import 'package:instax/data/data_sources/remote/fiirebase_firestore/calling_rooms/calling_rooms.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/notification/device_notification.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/push_notification.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/call_meet.dart';
import 'package:instax/domain/repositories/calling_room_repository.dart';

import '../../core/utils/constants.dart';
import '../data_sources/remote/fiirebase_firestore/user/firestore_user.dart';

class CallingRoomRepoImpl implements CallingRoomRepository {
  final FireStoreCallingRooms _rooms;
  final FireStoreUser _fireStoreUser;

  CallingRoomRepoImpl(this._rooms, this._fireStoreUser);

  @override
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required List<UserPersonalInfo> callThoseUsersInfo}) async {
    try {
      String channelId = await _rooms.createCallingRoom(
          myPersonalInfo: myPersonalInfo,
          initialNumberOfUsers: callThoseUsersInfo.length + 1);
      List<bool> isUsersAvailable = await _fireStoreUser.updateChannelId(
          callThoseUser: callThoseUsersInfo,
          myPersonalId: myPersonalInfo.userId,
          channelId: channelId);
      bool isAnyOneAvailable = false;

      for (int i = 0; i < isUsersAvailable.length; i++) {
        if (isUsersAvailable[i]) {
          isAnyOneAvailable = true;
          UserPersonalInfo receiverInfo =
              await _fireStoreUser.getUserInfo(callThoseUsersInfo[i].userId);
          String token = receiverInfo.deviceToken;
          if (token.isNotEmpty) {
            String body = "Calling you..";
            PushNotification detail = PushNotification(
                body: body,
                title: myPersonalInfo.name,
                deviceToken: token,
                routeParameterId: channelId,
                notificationRoute: "call",
                userCallingId: myPersonalInfo.userId,
                isThatGroupChat: callThoseUsersInfo.length > 1);

            await DeviceNotification.sendPopupNotification(
                pushNotification: detail);
          }
        }
      }
      if (isAnyOneAvailable) {
        return channelId;
      } else {
        throw Exception("Busy");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteRoom(
      {required String channelId, required List usersIds}) async {
    try {
      await _fireStoreUser.clearChannelsIds(
          userIds: usersIds, myPersonalId: myPersonalId);
      return await _rooms.deleteTheRoom(channelId: channelId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<bool> getCallingStatus({required String channelUid}) =>
      _rooms.getCallingStatus(channelUid: channelUid);

  @override
  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required channelId}) async {
    try {
      return await _rooms.getUsersInfoInThisRoom(channelId: channelId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<String> joinToRoom(
      {required String channelId,
      required UserPersonalInfo myPersonalInfo}) async {
    try {
      return await _rooms.joinToRoom(
          channelId: channelId, myPersonalInfo: myPersonalInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> leaveTheRoom(
      {required String userId,
      required String channelId,
      required bool isThatAfterJoining}) async {
    try {
      await _fireStoreUser.cancelJoiningToRoom(userId);
      await _rooms.removeThisUserFromRoom(
          userId: userId,
          channelId: channelId,
          isThatAfterJoining: isThatAfterJoining);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
