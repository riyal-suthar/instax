import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/notification/device_notification.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/user/firestore_user.dart';
import 'package:instax/data/models/child_classes/notification.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/notification_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FireStoreNotification {
  Future<UserPersonalInfo> createNewDeviceToken(
      {required String userId, required UserPersonalInfo myPersonalInfo});
  Future<void> deleteDeviceToken({required String userId});
  Future<String> createNotification(CustomNotification customNotification);
  Future<List<CustomNotification>> getNotifications({required String userId});
  Future<void> deleteNotification({required NotificationCheck notification});
}

class FireStoreNotificationImpl implements FireStoreNotification {
  final _userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<UserPersonalInfo> createNewDeviceToken(
      {required String userId,
      required UserPersonalInfo myPersonalInfo}) async {
    final SharedPreferences sharedPrefs = GetIt.I<SharedPreferences>();

    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null && !(myPersonalInfo.deviceToken == token)) {
      await _userCollection.doc(userId).update({"deviceToken": token});
      myPersonalInfo.deviceToken = token;
      await sharedPrefs.setString("deviceToken", token);
    }
    return myPersonalInfo;
  }

  @override
  Future<void> deleteDeviceToken({required String userId}) async {
    await _userCollection.doc(userId).update({"deviceToken": ""});
  }

  @override
  Future<String> createNotification(CustomNotification newNotification) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _userCollection.doc(newNotification.receiverId);

    userCollection
        .update({"numberOfNewNotifications": FieldValue.increment(1)});
    // get receiver token to push the notification
    UserPersonalInfo receiverInfo =
        await FireStoreUserImpl().getUserInfo(newNotification.receiverId);
    String token = receiverInfo.deviceToken;
    if (token.isNotEmpty) {
      await DeviceNotification.pushNotification(
          customNotification: newNotification, token: token);
    }
    return await _createNotification(newNotification);
  }

  Future<String> _createNotification(CustomNotification newNotification) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _userCollection.doc(newNotification.receiverId);
    CollectionReference<Map<String, dynamic>> colection =
        userCollection.collection("notifications");

    DocumentReference<Map<String, dynamic>> addNotification =
        await colection.add(newNotification.toMap());
    newNotification.notificationUid = addNotification.id;
    await addNotification.update({"notificationUid": addNotification.id});
    return newNotification.notificationUid;
  }

  @override
  Future<List<CustomNotification>> getNotifications(
      {required String userId}) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _userCollection.doc(userId);
    userCollection.update({"numberOfNewNotifications": 0});
    QuerySnapshot<Map<String, dynamic>> snap =
        await userCollection.collection("notifications").get();

    List<CustomNotification> notifications = [];
    for (final doc in snap.docs) {
      final notification = CustomNotification.fromJson(doc.data());
      notifications.add(notification);
    }
    return notifications;
  }

  @override
  Future<void> deleteNotification(
      {required NotificationCheck notification}) async {
    CollectionReference<Map<String, dynamic>> collection = _userCollection
        .doc(notification.receiverId)
        .collection("notifications");
    QuerySnapshot<Map<String, dynamic>> snap;

    if (notification.isThatPost) {
      snap = await collection
          .where("isThatLike", isEqualTo: notification.isThatLike)
          .where("isThatPost", isEqualTo: notification.isThatPost)
          .where("senderId", isEqualTo: notification.senderId)
          .where("postId", isEqualTo: notification.postId)
          .get();
    } else {
      snap = await collection
          .where("senderId", isEqualTo: notification.senderId)
          .where("postId", isEqualTo: notification.postId)
          .get();
    }

    for (final doc in snap.docs) {
      collection.doc(doc.id).delete();
    }
  }
}
