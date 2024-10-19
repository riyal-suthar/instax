import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instax/core/resources/assets_manager.dart';
import 'package:instax/presentation/pages/activity/activity_for_mobile.dart';

class ActivityForWeb extends StatelessWidget {
  const ActivityForWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 20,
      color: Theme.of(context).splashColor,
      offset: const Offset(90, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SvgPicture.asset(
        IconsAssets.add2Icon,
        colorFilter:
            ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
        height: 700,
        width: 500,
      ),
      itemBuilder: (context) => [const PopupMenuItem(child: ActivityPage())],
    );
  }
}
