import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:instax/core/utils/private_keys.dart';
import 'package:instax/data/models/child_classes/notification.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/push_notification.dart';

abstract class DeviceNotification {
  static Future<void> pushNotification(
      {required CustomNotification customNotification,
      required String token}) async {
    String notificationRoute;
    String routeParameterId;

    if (customNotification.isThatPost) {
      notificationRoute = "post";
      routeParameterId = customNotification.postId;
    } else {
      notificationRoute = "profile";
      routeParameterId = customNotification.senderId;
    }

    PushNotification detail = PushNotification(
      body: customNotification.text,
      title: customNotification.senderName,
      deviceToken: token,
      routeParameterId: routeParameterId,
      notificationRoute: notificationRoute,
      isThatGroupChat: false,
      userCallingId: "",
    );

    return await sendPopupNotification(pushNotification: detail);
  }

  // get your notification key
  static Future<void> sendPopupNotification(
      {required PushNotification pushNotification}) async {
    try {
      try {
        await http.post(
          Uri.parse(Env.notificationSendUri),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: Env.notificationKey,
          },
          body: jsonEncode(pushNotification.toMap()),
        );
      } catch (e, s) {
        if (kDebugMode) print(s);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
