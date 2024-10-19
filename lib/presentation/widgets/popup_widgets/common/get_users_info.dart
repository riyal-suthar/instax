import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:get/get.dart';
import '../../../cubit/user_info/specifc_users_info_cubit.dart';

import '../../../pages/profile/widgets/show_me_the _users.dart';
import '../../custom_widgets/custom_circulars_progress_indicators.dart';

class GetUsersInfo extends StatefulWidget {
  final List<dynamic> usersIds;
  final bool isThatFollowers;
  final bool isThatMyPersonalId;
  const GetUsersInfo(
      {super.key,
      required this.usersIds,
      this.isThatFollowers = true,
      required this.isThatMyPersonalId});

  @override
  State<GetUsersInfo> createState() => _GetUsersInfoState();
}

class _GetUsersInfoState extends State<GetUsersInfo> {
  ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rebuildUsersInfo,
      builder: (context, bool rebuildValue, child) =>
          BlocBuilder<SpecificUsersInfoCubit, SpecificUsersInfoState>(
              bloc: BlocProvider.of<SpecificUsersInfoCubit>(context)
                ..getSpecificUsersInfo(usersIds: widget.usersIds),
              buildWhen: (previous, current) {
                if (previous != current && current is SpecificUsersLoaded) {
                  return true;
                }
                if (rebuildValue && current is SpecificUsersLoaded) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is SpecificUsersLoaded) {
                  return ShowMeTheUsers(
                    usersInfo: state.specificUsersInfo,
                    emptyText: widget.isThatFollowers
                        ? StringsManager.noFollowers
                        : StringsManager.noFollowings,
                    isThatMyPersonalId: widget.isThatMyPersonalId,
                  );
                }
                if (state is SpecificUsersFailed) {
                  ToastMessage.toastStateError(state);
                  return Text(StringsManager.somethingWrong.tr);
                } else {
                  return const ThineCircularProgress();
                }
              }),
    );
  }
}
