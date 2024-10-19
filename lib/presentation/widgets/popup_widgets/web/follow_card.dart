import 'package:flutter/material.dart';
import 'package:instax/core/resources/color_manager.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/presentation/widgets/popup_widgets/common/get_users_info.dart';
import 'package:instax/presentation/widgets/popup_widgets/common/head_of_popup_widget.dart';

class PopupFollowCard extends StatelessWidget {
  final bool isThatFollower;
  final List<dynamic> usersIds;
  final bool isThatMyPersonalId;
  const PopupFollowCard(
      {super.key,
      required this.isThatFollower,
      required this.usersIds,
      required this.isThatMyPersonalId});

  @override
  Widget build(BuildContext context) {
    bool minimumOfWidth = MediaQuery.of(context).size.width > 600;
    return Center(
      child: SizedBox(
        width: minimumOfWidth ? 420 : 330,
        height: 450,
        child: Material(
          color: ColorManager.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                TheHeadWidget(
                    text: isThatFollower
                        ? StringsManager.followers
                        : StringsManager.following),
                const Divider(
                  color: ColorManager.grey,
                  thickness: 0.2,
                ),
                Expanded(
                    child: GetUsersInfo(
                  usersIds: usersIds,
                  isThatMyPersonalId: isThatMyPersonalId,
                  isThatFollowers: isThatFollower,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
