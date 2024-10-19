import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/call_meet.dart';

abstract class CallingRoomRepository {
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required List<UserPersonalInfo> callThoseUsersInfo});

  Stream<bool> getCallingStatus({required String channelUid});

  Future<String> joinToRoom(
      {required String channelId, required UserPersonalInfo myPersonalInfo});

  Future<void> leaveTheRoom(
      {required String userId,
      required String channelId,
      required bool isThatAfterJoining});

  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required channelId});

  Future<void> deleteRoom(
      {required String channelId, required List<dynamic> usersIds});
}
