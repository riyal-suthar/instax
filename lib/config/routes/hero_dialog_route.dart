import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:instax/core/resources/color_manager.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  final Color? backgroundColor;

  HeroDialogRoute(
      {super.settings,
      super.fullscreenDialog,
      super.allowSnapshotting,
      super.barrierDismissible,
      this.backgroundColor,
      required WidgetBuilder builder})
      : _builder = builder;

  final WidgetBuilder _builder;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => backgroundColor ?? ColorManager.black54;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => 'Popup dialog open';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
