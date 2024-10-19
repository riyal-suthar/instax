class PushNotification {
  final String body;
  final String title;
  final String deviceToken;
  final String routeParameterId;
  final String notificationRoute;
  final String? userCallingId;
  bool isThatGroupChat;

  PushNotification({
    required this.body,
    required this.title,
    required this.deviceToken,
    required this.routeParameterId,
    required this.notificationRoute,
    this.userCallingId,
    this.isThatGroupChat = false,
  });

  // Map<String, dynamic> toMap() => {
  //       "notification": <String, dynamic>{"body": body, "titile": title},
  //       "priority": "high",
  //       "data": <String, dynamic>{
  //         "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //         "route": notificationRoute,
  //         "routeParameterId": routeParameterId,
  //         "userCallingId": userCallingId,
  //         "isThatGroupChat": isThatGroupChat,
  //       },
  //       "to": deviceToken
  //     };

  Map<String, dynamic> toMap() => {
        "message": {
          "token": deviceToken,
          "notification": <String, dynamic>{"body": body, "title": title},
          "priority": "high",
          "data": <String, dynamic>{
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "route": notificationRoute,
            "routeParameterId": routeParameterId,
            "userCallingId": userCallingId,
            "isThatGroupChat": isThatGroupChat,
          }
        }
      };
}
