import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instax/core/functions/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';
import '../utils/constants.dart';
import '../utils/injector.dart';

Future<String?> initializeDefaultValues() async {
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    initializeDependencies(),
    GetStorage.init("AppLang"),
  ]);

  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

  final sharePrefs = injector<SharedPreferences>();
  String? myId = sharePrefs.getString("myPersonalId");
  if (myId != null) myPersonalId = myId;
  return myId;
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.data.toString());
    print(message.notification!.title);
  }
}
