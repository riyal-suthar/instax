// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:instax/domain/entities/call_entity.dart';
// import 'package:instax/presentation/cubit/agora_cubit/agora/agora_cubit.dart';
// import 'package:instax/presentation/cubit/agora_cubit/call/call_cubit.dart';
//
// class CallPage extends StatefulWidget {
//   final CallEntity callEntity;
//   const CallPage({Key? key, required this.callEntity}) : super(key: key);
//
//   @override
//   State<CallPage> createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//   @override
//   void initState() {
//     BlocProvider.of<AgoraCubit>(context).initialize(
//         channelName: widget.callEntity.callId!,
//         tokenUrl:
//             "http://192.168.244.3:3000/get_token?channelName=${widget.callEntity.callId}");
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final agoraProvider = BlocProvider.of<AgoraCubit>(context);
//
//     return Scaffold(
//       body: agoraProvider.getAgoraClient == null
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.blue,
//               ),
//             )
//           : SafeArea(
//               child: Stack(
//                 children: [
//                   AgoraVideoViewer(client: agoraProvider.getAgoraClient!),
//                   AgoraVideoButtons(
//                     client: agoraProvider.getAgoraClient!,
//                     disconnectButtonChild: IconButton(
//                       color: Colors.red,
//                       onPressed: () async {
//                         await agoraProvider.leaveChannel().then((value) {
//                           BlocProvider.of<CallCubit>(context)
//                               .endCall(CallEntity(
//                             callerId: widget.callEntity.callerId,
//                             receiverId: widget.callEntity.receiverId,
//                           ));
//                         });
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.call_end),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
