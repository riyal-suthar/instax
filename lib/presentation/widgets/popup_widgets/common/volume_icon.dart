import 'package:flutter/material.dart';

import '../../../../core/resources/color_manager.dart';

class VolumeIcon extends StatelessWidget {
  final bool isVolumeOn;
  const VolumeIcon({super.key, this.isVolumeOn = true});

  @override
  Widget build(BuildContext context) {
    IconData icon = isVolumeOn ? Icons.volume_up : Icons.volume_off;
    return Container(
      height: 23,
      width: 23,
      padding: const EdgeInsetsDirectional.all(2),
      decoration: BoxDecoration(
        color: ColorManager.black54,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Center(
        child: Icon(icon, color: ColorManager.white, size: 15),
      ),
    );
  }
}
