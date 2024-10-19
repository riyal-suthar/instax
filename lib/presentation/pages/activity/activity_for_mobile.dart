import "package:get/get.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/core/resources/styles_manager.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/presentation/cubit/notification_cubit/notification_cubit.dart';
import 'package:instax/presentation/pages/profile/widgets/show_me_the%20_users.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_circulars_progress_indicators.dart';
import 'package:instax/presentation/widgets/other_widgets/notification_card_info.dart';

import '../../../data/models/child_classes/notification.dart';
import '../../cubit/user_info/user_info_cubit.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late UserPersonalInfo myPersonalInfo;
  final ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isThatMobile
        ? Scaffold(
            appBar: AppBar(
              title: Text(StringsManager.activity.tr),
            ),
            body: buildBody(context),
          )
        : buildBody(context);
  }

  BlocBuilder<UserInfoCubit, UserInfoState> buildBody(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      bloc: UserInfoCubit.get(context)..getAllUnFollowersUsers(myPersonalInfo),
      buildWhen: (prev, curr) =>
          (prev != curr && curr is AllUnFollowersUserLoaded),
      builder: (context, unFollowerState) {
        return BlocBuilder<NotificationCubit, NotificationState>(
          bloc: NotificationCubit.get(context)
            ..getNotifications(userId: myPersonalId),
          buildWhen: (prev, curr) =>
              (prev != curr && curr is NotificationLoaded),
          builder: (context, notificationState) {
            if (notificationState is NotificationLoaded &&
                unFollowerState is AllUnFollowersUserLoaded) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notificationState.notifications.isNotEmpty)
                      _ShowNotifications(
                          notifications: notificationState.notifications),
                    if (unFollowerState.usersInfo.isNotEmpty) ...[
                      suggestionForYouText(context),
                      ShowMeTheUsers(
                        usersInfo: unFollowerState.usersInfo,
                        emptyText: StringsManager.noActivity.tr,
                        isThatMyPersonalId: true,
                        showColorfulCircle: false,
                      ),
                    ]
                  ],
                ),
              );
            } else if (notificationState is NotificationFailed &&
                unFollowerState is AllUnFollowersUserLoaded) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    suggestionForYouText(context),
                    ShowMeTheUsers(
                      usersInfo: unFollowerState.usersInfo,
                      emptyText: StringsManager.noActivity.tr,
                      showColorfulCircle: false,
                      isThatMyPersonalId: true,
                    )
                  ],
                ),
              );
            } else if (notificationState is NotificationLoaded &&
                unFollowerState is GetUserInfoFailed) {
              return SingleChildScrollView(
                child: _ShowNotifications(
                    notifications: notificationState.notifications),
              );
            } else if (notificationState is NotificationFailed &&
                unFollowerState is GetUserInfoFailed) {
              ToastMessage.toast(notificationState.error);
              return Center(
                child: Text(
                  StringsManager.somethingWrong.tr,
                  style: getNormalStyle(color: Theme.of(context).focusColor),
                ),
              );
            }

            return const Center(
              child: ThineCircularProgress(),
            );
          },
        );
      },
    );
  }

  Padding suggestionForYouText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        StringsManager.suggestionsForYou.tr,
        style:
            getMediumStyle(color: Theme.of(context).focusColor, fontSize: 16),
      ),
    );
  }
}

class _ShowNotifications extends StatefulWidget {
  final List<CustomNotification> notifications;
  const _ShowNotifications({super.key, required this.notifications});

  @override
  State<_ShowNotifications> createState() => _ShowNotificationsState();
}

class _ShowNotificationsState extends State<_ShowNotifications> {
  late UserPersonalInfo myPersonalInfo;

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notifications.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
          return NotificationCardInfo(
              notificationInfo: widget.notifications[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: widget.notifications.length,
      );
    } else {
      return Center(
        child: Text(
          StringsManager.noActivity.tr,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
  }
}
