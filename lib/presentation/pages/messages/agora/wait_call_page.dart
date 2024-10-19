import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/domain/entities/call_entity.dart';
import 'package:instax/presentation/pages/agora_video_call/call_page.dart';
import 'package:instax/presentation/pages/messages/agora/video_call_screen.dart';
import 'package:instax/presentation/pages/messages/video_call_page.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../cubit/callingRomms/bloc/calling_status_bloc.dart';
import '../../../cubit/callingRomms/calling_rooms_cubit.dart';

class VideoCallPage extends StatelessWidget {
  final List<UserPersonalInfo> usersInfo;
  final UserPersonalInfo myPersonalInfo;

  const VideoCallPage({
    Key? key,
    required this.usersInfo,
    required this.myPersonalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorManager.lowOpacityGrey,
      body: SafeArea(
        child: BlocBuilder<CallingRoomsCubit, CallingRoomsState>(
          buildWhen: (previous, current) =>
              previous != current && current is CallingRoomsLoaded,
          bloc: CallingRoomsCubit.get(context)
            ..createCallingRoom(
                myPersonalInfo: myPersonalInfo, callThoseUser: usersInfo),
          builder: (callingRoomContext, callingRoomState) {
            if (callingRoomState is CallingRoomsLoaded) {
              return callingRoomsLoaded(callingRoomState, callingRoomContext);
            } else if (callingRoomState is CallingRoomsFailed) {
              return whichFailedText(callingRoomState, callingRoomContext);
            } else {
              return callingLoadingPage();
            }
          },
        ),
      ),
    );
  }

  Widget callingRoomsLoaded(
      CallingRoomsLoaded roomsState, BuildContext context) {
    return BlocBuilder<CallingStatusBloc, CallingStatusState>(
      bloc: BlocProvider.of<CallingStatusBloc>(context)
        ..add(LoadCallingStatus(roomsState.channelId)),
      builder: (context, callingStatusState) {
        bool isAllUsersCanceled = callingStatusState is CallingStatusLoaded &&
            callingStatusState.callingStatus == false;

        bool isThereAnyProblem = callingStatusState is CallingStatusFailed;

        if (isAllUsersCanceled || isThereAnyProblem) {
          return canceledText(roomsState, context);
        } else {
          return callPage(roomsState);
        }
      },
    );
  }

  Widget callPage(CallingRoomsLoaded roomsState) {
    // return CallPage(
    //     callEntity: CallEntity(
    //   callerId: myPersonalInfo.userId,
    //   callerName: myPersonalInfo.userName,
    //   callerProfileUrl: myPersonalInfo.profileImageUrl,
    //   receiverId: usersInfo[0].userId,
    //   receiverName: usersInfo[0].userName,
    //   receiverProfileUrl: usersInfo[0].profileImageUrl,
    // ));
    return VideoCallScreen(
      channelName: myPersonalInfo.channelId,
    );
  }

  Widget canceledText(CallingRoomsLoaded roomsState, BuildContext context) {
    List<dynamic> usersIds = [];
    usersInfo.where((element) {
      usersIds.add(element.userId);
      return true;
    }).toList();
    CallingRoomsCubit.get(context)
        .deleteTheRoom(channelId: roomsState.channelId, userIds: usersIds);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2)).then((value) {
        Navigator.of(context).maybePop();
      });
    });
    return const Center(
        child: Text("Canceled...",
            style: TextStyle(fontSize: 20, color: Colors.black87)));
  }

  Widget whichFailedText(CallingRoomsFailed state, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.of(context).maybePop();
      });
    });
    if (state.error == "Busy") {
      String message = usersInfo.length > 1
          ? "They are all busy..."
          : '${usersInfo[0].name} is Busy...';
      return Center(child: Text(message));
    } else {
      return const Center(child: Text("Call ended..."));
    }
  }

  Widget callingLoadingPage() {
    return Center(
      child: Text("Connecting...",
          style: getNormalStyle(color: ColorManager.black, fontSize: 25)),
    );
  }
}
