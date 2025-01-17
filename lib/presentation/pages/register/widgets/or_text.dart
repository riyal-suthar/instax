import 'package:flutter/material.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';

class OrText extends StatelessWidget {
  const OrText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(
          indent: 30,
          endIndent: 20,
          thickness: 0.2,
          color: ColorManager.grey,
        )),
        Text(
          StringsManager.or,
          style: getBoldStyle(color: Theme.of(context).disabledColor),
        ),
        const Expanded(
            child: Divider(
          indent: 20,
          endIndent: 30,
          thickness: 0.2,
          color: ColorManager.grey,
        )),
      ],
    );
  }
}
