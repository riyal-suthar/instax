// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:instax/config/routes/app_routes.dart';
// import 'package:instax/core/utils/injector.dart';
// import 'package:instax/domain/entities/call_entity.dart';
// import 'package:instax/domain/usecases/agora_usecases/get_call_channelId_usecase.dart';
// import 'package:instax/presentation/cubit/agora_cubit/agora/agora_cubit.dart';
// import 'package:instax/presentation/cubit/agora_cubit/call/call_cubit.dart';
// import 'package:instax/presentation/pages/agora_video_call/call_page.dart';
// import 'package:instax/presentation/pages/agora_video_call/profile.dart';
//
// class PickUpCallPage extends StatefulWidget {
//   final String? uid;
//   final Widget child;
//
//   const PickUpCallPage({Key? key, required this.child, this.uid})
//       : super(key: key);
//
//   @override
//   State<PickUpCallPage> createState() => _PickUpCallPageState();
// }
//
// class _PickUpCallPageState extends State<PickUpCallPage> {
//   @override
//   void initState() {
//     // BlocProvider.of<CallCubit>(context).getUserCalling(widget.uid!);
//     // CallCubit.get(context).getUserCalling(widget.uid!);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CallCubit, CallState>(
//       bloc: CallCubit.get(context)..getUserCalling(widget.uid!),
//       builder: (context, callState) {
//         if (callState is CallDialed) {
//           final call = callState.userCall;
//
//           if (call.isCallDialed == false) {
//             return Scaffold(
//               body: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 40),
//                   const Text(
//                     'Incoming Call',
//                     style: TextStyle(
//                       fontSize: 30,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   profileWidget(imageUrl: call.receiverProfileUrl),
//                   const SizedBox(height: 40),
//                   Text(
//                     "${call.receiverName}",
//                     style: const TextStyle(
//                       fontSize: 25,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () async {
//                           BlocProvider.of<AgoraCubit>(context)
//                               .leaveChannel()
//                               .then((value) {
//                             BlocProvider.of<CallCubit>(context)
//                                 .updateCallHistoryStatus(CallEntity(
//                                     callId: call.callId,
//                                     callerId: call.callerId,
//                                     receiverId: call.receiverId,
//                                     isCallDialed: false,
//                                     isMissed: true))
//                                 .then((value) {
//                               BlocProvider.of<CallCubit>(context)
//                                   .endCall(CallEntity(
//                                 callerId: call.callerId,
//                                 receiverId: call.receiverId,
//                               ));
//                             });
//                           });
//                         },
//                         icon:
//                             const Icon(Icons.call_end, color: Colors.redAccent),
//                       ),
//                       const SizedBox(width: 25),
//                       IconButton(
//                         onPressed: () {
//                           injector<GetCallChannelIdUseCase>()
//                               .call(call.receiverId!)
//                               .then((callChannelId) {
//                             Go(context).push(
//                                 page: CallPage(
//                                     callEntity: CallEntity(
//                                         callId: callChannelId,
//                                         callerId: call.callerId!,
//                                         receiverId: call.receiverId!)));
//
//                             print("callChannelId = $callChannelId");
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.call,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }
//           return widget.child;
//         }
//         return widget.child;
//       },
//     );
//   }
// }
