import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/presentation/pages/profile/widgets/show_me_the%20_users.dart';

import '../../../core/resources/strings_manager.dart';
import '../../cubit/user_info/specifc_users_info_cubit.dart';
import '../../widgets/custom_widgets/custom_circulars_progress_indicators.dart';

class UsersWhoLikes extends StatelessWidget {
  final List<dynamic> usersIds;
  final bool showSearchBar;
  final bool showColorfulCircle;
  final bool isThatMyPersonalId;

  const UsersWhoLikes({
    Key? key,
    required this.showSearchBar,
    required this.usersIds,
    required this.isThatMyPersonalId,
    this.showColorfulCircle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<SpecificUsersInfoCubit>(context)
        ..getSpecificUsersInfo(usersIds: usersIds),
      buildWhen: (previous, current) =>
          previous != current && current is SpecificUsersLoaded,
      builder: (context, state) {
        if (state is SpecificUsersLoaded) {
          return ShowMeTheUsers(
            usersInfo: state.specificUsersInfo,
            emptyText: StringsManager.noUsers.tr,
            showColorfulCircle: showColorfulCircle,
            isThatMyPersonalId: isThatMyPersonalId,
          );
        }
        if (state is SpecificUsersFailed) {
          ToastMessage.toastStateError(state);
          return Center(
            child: Text(StringsManager.somethingWrong.tr,
                style: Theme.of(context).textTheme.bodyLarge),
          );
        } else {
          return const Center(child: ThineCircularProgress());
        }
      },
    );
  }
}
