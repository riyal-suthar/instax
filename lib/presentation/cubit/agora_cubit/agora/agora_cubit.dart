import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/utils/private_keys.dart';

part 'agora_state.dart';

class AgoraCubit extends Cubit<AgoraState> {
  static final AgoraCubit _instance = AgoraCubit._internal();
  static AgoraCubit get(context) => BlocProvider.of<AgoraCubit>(context);
  AgoraClient? _client;

  factory AgoraCubit() => _instance;

  AgoraCubit._internal() : super(AgoraInitial());

  Future<void> initialize({String? tokenUrl, String? channelName}) async {
    if (_client == null) {
      _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: Env.agoraAppId,
          channelName: channelName!,
          // tokenUrl: tokenUrl,
        ),
      );
      await _client!.initialize();
    }
  }

  Future<void> leaveChannel() async {
    if (_client != null) {
      await _client!.engine.leaveChannel();
      await _client!.engine.release();
      _client = null; // Reset the client
    }
  }

  AgoraClient? get getAgoraClient => _client;
}
