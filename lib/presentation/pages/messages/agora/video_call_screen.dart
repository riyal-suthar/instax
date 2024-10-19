import 'dart:async';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/presentation/cubit/agora_cubit/agora/agora_cubit.dart';
import 'package:instax/presentation/cubit/callingRomms/calling_rooms_cubit.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  const VideoCallScreen({
    super.key,
    required this.channelName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late Timer timer;
  int elapsedTimeInSeconds = 0;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTimeInSeconds++;
      });
    });

    super.initState();

    // GET TEMPERORY RTC TOKEN AFTER GENERATING CERTIFICATE IN AGORA
    //                             OR
    // IN FIREBASE YOU CAN WRITE CLOUD FUNCTION FOR GENERATING UNIQUE TOKENS

    AgoraCubit.get(context).initialize(
      channelName: widget.channelName,
      // tokenUrl:
      //     "http://192.168.130.13:3000/get_token?channelName=${widget.channelName}",
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agoraProvider = BlocProvider.of<AgoraCubit>(context);

    return Scaffold(
      body: agoraProvider.getAgoraClient == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Stack(
              children: [
                AgoraVideoViewer(client: agoraProvider.getAgoraClient!),
                AgoraVideoButtons(
                  client: agoraProvider.getAgoraClient!,
                  disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await agoraProvider.leaveChannel().then((value) {
                          BlocProvider.of<CallingRoomsCubit>(context)
                              .deleteTheRoom(channelId: widget.channelName);
                        });
                      },
                      icon: const Icon(Icons.call_end)),
                )
              ],
            )),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     automaticallyImplyLeading: false,
    //     title: const Text('Video Call'),
    //     actions: [
    //       // Timer display
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(
    //           '${Duration(seconds: elapsedTimeInSeconds).inMinutes}:${Duration(seconds: elapsedTimeInSeconds).inSeconds.remainder(60)}',
    //           style: const TextStyle(color: Colors.white),
    //         ),
    //       ),
    //     ],
    //   ),
    //   body: SafeArea(
    //     child: Stack(
    //       children: [
    //         // video call screen
    //         Container(
    //           child: AgoraVideoViewer(
    //             client: client,
    //             layoutType: Layout.floating,
    //             floatingLayoutContainerHeight: 100,
    //             floatingLayoutContainerWidth: 100,
    //             showNumberOfUsers: true,
    //             showAVState: true,
    //           ),
    //         ),
    //         AgoraVideoButtons(client: client),
    //       ],
    //     ),
    //   ),
    // );
  }
}
