// import 'package:flutter/material.dart';
// import 'package:instax/presentation/cubit/callingRomms/calling_rooms_cubit.dart';
// import 'dart:async';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import '../../../core/utils/private_keys.dart';
// import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
// import '../../cubit/user_info/user_info_cubit.dart';
// import '../../widgets/circle_avatar_image/circle_avatar_of_profile_image.dart';
//
// enum UserCallingType { sender, receiver }
//
// class CallPage extends StatefulWidget {
//   final String channelName;
//   final String userCallingId;
//
//   final List<UserPersonalInfo>? usersInfo;
//   final UserCallingType userCallingType;
//   final ClientRoleType role;
//
//   const CallPage({
//     Key? key,
//     required this.channelName,
//     this.userCallingId = "",
//     required this.userCallingType,
//     required this.role,
//     this.usersInfo,
//   }) : super(key: key);
//
//   @override
//   CallPageState createState() => CallPageState();
// }
//
// class CallPageState extends State<CallPage> {
//   final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   bool moreThanOne = false;
//
//   late RtcEngine _engine;
//   int? _remoteUid;
//   bool _localUserJoined = true;
//
//   late UserPersonalInfo myPersonalInfo;
//   @override
//   void dispose() {
//     _users.clear();
//     _dispose();
//     super.dispose();
//   }
//
//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
//     WidgetsBinding.instance.addPostFrameCallback((_) async => await onJoin());
//
//     initialize();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     WidgetsBinding.instance.addPostFrameCallback((_) async => await onJoin());
//   }
//
//   Future<void> onJoin() async {
//     await _handleCameraAndMic(Permission.camera);
//     await _handleCameraAndMic(Permission.microphone);
//   }
//
//   Future<void> _handleCameraAndMic(Permission permission) async =>
//       await permission.request();
//
//   /// Create your own app id with agora with "testing mode"
//   /// it's very simple, just go to https://www.agora.io/en/ and create your own project and get your own app id in [agoraAppId]
//   /// Again, don't make it with secure mode ,You will lose the creation of several channels.
//   /// Make it with "testing mode"
//   Future<void> initialize() async {
//     if (agoraAppId.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }
//
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//
//     await _engine.setClientRole(role: widget.role);
//     await _engine.enableVideo();
//     await _engine.startPreview();
//
//     await _engine.joinChannel(
//         token: agoraToken,
//         channelId: widget.channelName,
//         uid: 0,
//         options: const ChannelMediaOptions());
//
//     // VideoEncoderConfiguration configuration = const VideoEncoderConfiguration();
//     // configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
//     // await _engine.setVideoEncoderConfiguration(configuration);
//   }
//
//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = createAgoraRtcEngine();
//     await _engine.enableVideo();
//     // await _engine.setChannelProfile(profile)
//     await _engine.initialize(const RtcEngineContext(
//       appId: agoraAppId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//   }
//
//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     _engine.registerEventHandler(RtcEngineEventHandler(
//         onError: (ErrorCodeType errorCode, String code) {
//       setState(() {
//         final info = 'onError : $code';
//         _infoStrings.add(info);
//       });
//     }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//       debugPrint("user ${connection.localUid} joined");
//       setState(() {
//         _localUserJoined = true;
//         final info =
//             'onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
//         _infoStrings.add(info);
//       });
//     }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//       debugPrint("remote user $remoteUid + ${connection.localUid} joined");
//       setState(() {
//         _remoteUid = remoteUid;
//         final info = 'userJoined: $remoteUid + ${connection.localUid}';
//         _infoStrings.add(info);
//         _users.add(remoteUid);
//       });
//     }, onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//       debugPrint("remote user $remoteUid left channel");
//       setState(() {
//         _remoteUid = null;
//         final info = 'userOffline: $remoteUid + ${connection.localUid}';
//         _infoStrings.add(info);
//         _users.remove(remoteUid);
//       });
//     }, onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//       debugPrint(
//           '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//     }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//       debugPrint("remote user ${connection.localUid} left");
//
//       // // added
//       if (!mounted) return;
//
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     }, onFirstRemoteVideoFrame: (RtcConnection connection, int remoteUid,
//             int width, int height, int elapsed) {
//       setState(() {
//         final info = 'firstRemoteVideo: $remoteUid ${width}x $height';
//         _infoStrings.add(info);
//       });
//     }));
//   }
//
//   Widget buildCircleAvatar(int index, double bodyHeight) {
//     return CircleAvatarOfProfileImage(
//       bodyHeight: bodyHeight,
//       userInfo: widget.usersInfo![index],
//       disablePressed: true,
//       showColorfulCircle: false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Agora Video Call'),
//         leading: IconButton(
//             onPressed: () {
//               CallingRoomsCubit.get(context).leaveTheRoom(
//                   userId: myPersonalInfo.userId,
//                   channelId: myPersonalInfo.channelId,
//                   isThatAfterJoining: moreThanOne);
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back)),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                         controller: VideoViewController(
//                           rtcEngine: _engine,
//                           canvas: const VideoCanvas(uid: 0),
//                         ),
//                       )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: widget.channelName),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
