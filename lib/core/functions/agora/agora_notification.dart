// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:instax/core/utils/constants.dart';
// import 'package:instax/core/utils/private_keys.dart';
// import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
//
// class AgoraNotification {
//   static final FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance;
//
//   static Future<void> getFirebaseMessagingToken() async {
//     // request permission
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: false,
//       criticalAlert: true,
//       provisional: false,
//       sound: true,
//     );
//
//     debugPrint('user granted permission : ${settings.authorizationStatus}');
//
//     FirebaseMessaging.onMessage.listen((message) {
//       if (message.notification != null) {
//         debugPrint(
//             'Message also contained a notification: ${message.notification}');
//       }
//     });
//
//     FirebaseMessaging.onBackgroundMessage(
//         (message) => _backgroundHandler(message));
//   }
//
//   // background message handler
//   static Future<void> _backgroundHandler(RemoteMessage message) async {
//     debugPrint("Handling a background message: ${message.messageId}");
//   }
//
//   static Future<void> sendPushNotifications(
//       UserPersonalInfo chatUser, String msg) async {
//     try {
//       final body = {
//         "to": chatUser.deviceToken,
//         "notification": {
//           "title": ".name",
//           "body": "msg",
//           "android_channel_id": "chats",
//           "sound": "default",
//         },
//         "data": {
//           "click_action": "FLUTTER_NOTIFICATION_CLICK",
//           "some_data": "User ID: ${myPersonalId}",
//         },
//         "priority": "high",
//         "content_available": true,
//       };
//
//       var response =
//           await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: {
//                 HttpHeaders.contentTypeHeader: 'application/json',
//                 HttpHeaders.authorizationHeader: notificationKey
//               },
//               body: jsonEncode(body));
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     } catch (e) {
//       print('\nsendPushNotification Error: $e');
//     }
//   }
//
//   // sending push notification for video calls
//   static Future<void> sendVideoCallPushNotification(
//     UserPersonalInfo chatUser,
//   ) async {
//     try {
//       final body = {
//         "to": chatUser.deviceToken,
//         "notification": {
//           "title": "me.name",
//           "body": 'Incoming Call from ${"me.name"}',
//           "android_channel_id": "chats",
//         },
//         "data": {
//           "click_action": "FLUTTER_NOTIFICATION_CLICK",
//           "some_data": "User ID: ${myPersonalId}",
//         },
//       };
//
//       var response =
//           await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: {
//                 HttpHeaders.contentTypeHeader:
//                     'application/json; charset=UTF-8',
//                 HttpHeaders.authorizationHeader:
//                     'key=AAAAfv393jU:APA91bGswPJx7mdyAgxSJH1W_qO-uxshvJYb1kAyJqCbvnPtj7I3XvKnwtbWECoDyFGIoePlzVleOsgEhC8JftHYPnO0spYH4c8cKoLVMgO8Qy1ycI7akLQcLdMQcZruueXd35Xf2RBR',
//               },
//               body: jsonEncode(body));
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     } catch (e) {
//       print('\nsendPushNotification Error: $e');
//     }
//   }
// }
