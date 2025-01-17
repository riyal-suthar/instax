import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/presentation/cubit/agora_cubit/agora/agora_cubit.dart';
import 'package:instax/presentation/pages/messages/agora/video_call_screen.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../../domain/entities/call_meet.dart';
import '../../../cubit/callingRomms/calling_rooms_cubit.dart';
import '../../../cubit/user_info/user_info_cubit.dart';

class CallingRingingPage extends StatefulWidget {
  final String channelId;
  final VoidCallback clearMoving;
  const CallingRingingPage(
      {Key? key, required this.channelId, required this.clearMoving})
      : super(key: key);

  @override
  State<CallingRingingPage> createState() => _CallingRingingPageState();
}

class _CallingRingingPageState extends State<CallingRingingPage> {
  bool pop = false;
  @override
  void dispose() {
    widget.clearMoving();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.grey,
      body: SafeArea(
        child: BlocBuilder<CallingRoomsCubit, CallingRoomsState>(
          bloc: CallingRoomsCubit.get(context)
            ..getUsersInfoInThisRoom(channelId: widget.channelId),
          builder: (context, state) {
            if (pop) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => pop = false);
                Navigator.of(context).maybePop();
              });
            }
            if (state is UsersInfoInRoomLoaded) {
              return callingLoadingPage(state.usersInfo);
            } else {
              return waitingText();
            }
          },
        ),
      ),
    );
  }

  Future<void> onTapAcceptButton() async {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    await CallingRoomsCubit.get(context).joinToRoom(
        channelId: widget.channelId, myPersonalInfo: myPersonalInfo);
    if (!mounted) return;

    await Go(context).push(
      // page: CallPage(
      //   channelName: widget.channelId,
      //   role: ClientRoleType.clientRoleAudience,
      //   userCallingType: UserCallingType.receiver,
      // ),
      page: VideoCallScreen(
        channelName: widget.channelId,
      ),
      withoutRoot: false,
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => pop = true));
  }

  Future<void> onTapCancelButton() async {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);

    AgoraCubit.get(context).leaveChannel();

    await CallingRoomsCubit.get(context).leaveTheRoom(
      userId: myPersonalInfo.userId,
      channelId: widget.channelId,
      isThatAfterJoining: false,
    );
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  Widget waitingText() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Someone calling you",
            style: getNormalStyle(color: ColorManager.white),
          ),
          Text(
            "Please wait for loaded...",
            style: getNormalStyle(color: ColorManager.white),
          ),
        ],
      ),
    );
  }

  Widget callingLoadingPage(List<UsersInfoInCallingRoom> userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 100),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (userInfo[0].profileImageUrl == null ||
                userInfo[0].profileImageUrl!.isEmpty)
              const Icon(
                Icons.person,
                size: 50,
              )
            else
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userInfo[0].profileImageUrl!),
              ),
            const SizedBox(height: 30),
            Text(userInfo[0].name!,
                style: getNormalStyle(color: ColorManager.white, fontSize: 25)),
            const SizedBox(height: 10),
            Text('Calling...',
                style:
                    getNormalStyle(color: ColorManager.white, fontSize: 16.5)),
          ],
        ),
        const Spacer(),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: onTapCancelButton,
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: ColorManager.red,
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapAcceptButton,
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: ColorManager.green,
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
