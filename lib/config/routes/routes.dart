import 'package:flutter/material.dart';
import 'package:instax/config/routes/routesName.dart';

class Routes {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.signInScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.signUpScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.messageScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.notificationScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.postScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.reelScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.storyScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.timelineScreen:
        return MaterialPageRoute(builder: (context) => Container());
      case RouteName.userProfileScreen:
        return MaterialPageRoute(builder: (context) => Container());

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
