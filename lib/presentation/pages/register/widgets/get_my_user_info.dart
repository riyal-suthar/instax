import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/presentation/cubit/user_info/user_info_cubit.dart';
import 'package:get/get.dart';
import 'package:instax/presentation/pages/register/widgets/popup_calling.dart';
import 'package:instax/presentation/responsive/responsive_layout.dart';
import 'package:instax/presentation/responsive/web_screen_layout.dart';

class GetMyPersonalInfo extends StatefulWidget {
  final String myPersonalId;
  const GetMyPersonalInfo({super.key, required this.myPersonalId});

  @override
  State<GetMyPersonalInfo> createState() => _GetMyPersonalInfoState();
}

class _GetMyPersonalInfoState extends State<GetMyPersonalInfo> {
  bool isHeMovedToHome = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoCubit, UserInfoState>(
      bloc: UserInfoCubit.get(context)
        ..getUserInfo(widget.myPersonalId, getDeviceToken: true),
      listenWhen: (prev, curr) => prev != curr,
      listener: (context, userState) {
        if (!isHeMovedToHome) {
          setState(() {
            isHeMovedToHome = true;
          });

          if (userState is CubitMyPersonalInfoLoaded) {
            myPersonalId = widget.myPersonalId;

            Get.offAll(() => ResponsiveLayout(
                mobileScreenLayout: PopupCalling(myPersonalId),
                webScreenLayout: const WebScreenLayout()));
          } else if (userState is GetUserInfoFailed) {
            ToastMessage.toastStateError(userState);
          }
        }
      },
      child: Container(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
