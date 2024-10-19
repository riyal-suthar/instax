import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/call_meet.dart';

abstract class FireStoreCallingRooms {
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required int initialNumberOfUsers});

  Future<void> removeThisUserFromRoom(
      {required String userId,
      required String channelId,
      required bool isThatAfterJoining});

  // Map<String, dynamic> _toMap(UserPersonalInfo myPersonalInfo,
  //     {int numberOfUsers = 1, int initialNumberOfUsers = 0});

  Future<String> joinToRoom(
      {required String channelId, required UserPersonalInfo myPersonalInfo});

  Stream<bool> getCallingStatus({required String channelUid});

  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId});

  Future<void> deleteTheRoom({required String channelId});
}

class FireStoreCallingRoomsImpl implements FireStoreCallingRooms {
  final _callingRoomCollection =
      FirebaseFirestore.instance.collection("callingRooms");

  // to save data as map in firestore
  Map<String, dynamic> _toMap(UserPersonalInfo myPersonalInfo,
          {int initialNumberOfUsers = 0, int numberOfUsers = 1}) =>
      {
        "numberOfUsersInRoom": numberOfUsers,
        if (initialNumberOfUsers != 0)
          "initialNumberOfUsers": initialNumberOfUsers,
        "usersInfo": {
          "${myPersonalInfo.userId}": {
            "name": myPersonalInfo.name,
            "profileImage": myPersonalInfo.profileImageUrl,
          }
        }
      };

  @override
  Future<String> createCallingRoom(
      {required UserPersonalInfo myPersonalInfo,
      required int initialNumberOfUsers}) async {
    DocumentReference<Map<String, dynamic>> collection =
        await _callingRoomCollection.add(
            _toMap(myPersonalInfo, initialNumberOfUsers: initialNumberOfUsers));

    _callingRoomCollection
        .doc(collection.id)
        .update({"channelId": collection.id});

    return collection.id;
  }

  @override
  Future<void> deleteTheRoom({required String channelId}) async {
    await _callingRoomCollection.doc(channelId).delete();
  }

  @override
  Stream<bool> getCallingStatus({required String channelUid}) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapSearch =
        _callingRoomCollection.doc(channelUid).snapshots();

    return snapSearch
        .map((snapshot) => snapshot.get("initialNumberOfUsers") != 1);
  }

  @override
  Future<List<UsersInfoInCallingRoom>> getUsersInfoInThisRoom(
      {required String channelId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _callingRoomCollection.doc(channelId).get();
    var data = snap.data();

    List<UsersInfoInCallingRoom> usersInfo = [];

    data?.forEach((key, value) {
      if (key == "usersInfo") {
        Map usersMap = value;
        usersMap.forEach((userId, value) {
          // Map userMap = value;
          usersInfo.add(UsersInfoInCallingRoom(
              userId: userId,
              name: value["name"],
              profileImageUrl: value["profileImage"]));
        });
      }
    });
    return usersInfo;
  }

  @override
  Future<String> joinToRoom(
      {required String channelId,
      required UserPersonalInfo myPersonalInfo}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _callingRoomCollection.doc(channelId).get();

    int numbersOfUsers = snap.get("numberOfUsersInRoom");

    _callingRoomCollection
        .doc(channelId)
        .update(_toMap(myPersonalInfo, numberOfUsers: numbersOfUsers + 1));

    return channelId;
  }

  @override
  Future<void> removeThisUserFromRoom(
      {required String userId,
      required String channelId,
      required bool isThatAfterJoining}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _callingRoomCollection.doc(channelId).get();

    int initialNumberOfUsers = snap.get("initialNumberOfUsers");
    int numbersOfUsersInRoom = snap.get("numbersOfUsersInRoom");

    dynamic usersInfo = snap.get("usersInfo");
    usersInfo.removeWhere((key, value) {
      if (key == "usersInfo") {
        value.removeWhere((key, value) => key == userId);
        return false;
      } else {
        return false;
      }
    });
    _callingRoomCollection.doc(channelId).update({
      "usersInfo": usersInfo,
      "initialNumberOfUsers": initialNumberOfUsers - 1,
      if (isThatAfterJoining) "numbersOfUsersInRoom": numbersOfUsersInRoom - 1,
    });
  }
}
