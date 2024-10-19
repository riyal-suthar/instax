import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instax/core/resources/assets_manager.dart';

class InstagramLogo extends StatelessWidget {
  final Color? color;
  final bool enableOnTapForWeb; 
  const InstagramLogo({super.key, this.color, this.enableOnTapForWeb=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enableOnTapForWeb
      ? (){} 
      : null,
      child: SvgPicture.asset(IconsAssets.instagramLogo,
      height: 32,
      colorFilter: ColorFilter.mode(color ?? Theme.of(context).focusColor, BlendMode.srcIn),
      ),
    );
  }
}