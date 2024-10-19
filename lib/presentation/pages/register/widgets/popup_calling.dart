import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../cubit/user_info/users_info_in_reel_time/users_info_in_reel_time_bloc.dart';
import '../../../responsive/mobile_screen_layout.dart';
import '../../messages/agora/ringing_page.dart';

class PopupCalling extends StatefulWidget {
  final String userId;

  const PopupCalling(this.userId, {Key? key}) : super(key: key);

  @override
  State<PopupCalling> createState() => _PopupCallingState();
}

class _PopupCallingState extends State<PopupCalling> {
  bool isHeMoved = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersInfoInReelTimeBloc, UsersInfoInReelTimeState>(
      bloc: UsersInfoInReelTimeBloc.get(context)..add(LoadMyPersonalInfo()),
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is MyPersonalInfoLoaded &&
              !amICalling &&
              state.myPersonalInfoInReelTime.channelId.isNotEmpty) {
            if (!isHeMoved) {
              isHeMoved = true;
              Go(context).push(
                  page: CallingRingingPage(
                      channelId: state.myPersonalInfoInReelTime.channelId,
                      clearMoving: clearMoving),
                  withoutRoot: false);
            }
          }
        });
        return MobileScreenLayout(widget.userId);
      },
    );
  }

  clearMoving() {
    isHeMoved = false;
  }
}
