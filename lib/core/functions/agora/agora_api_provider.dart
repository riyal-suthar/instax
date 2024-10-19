import 'package:agora_uikit/agora_uikit.dart';
import 'package:instax/core/utils/private_keys.dart';

class AgoraApiProvider {
  final AgoraClient _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: Env.agoraAppId,
          channelName: "instax",
          // tempToken: agoraToken,
          tokenUrl:
              "007eJxTYFCLfnkoTHHSdpusEBHLFT6r5n4rOp4pfdN72z3Fp/sXF5xQYDA2NEwySbE0Tza1tDAxMTS2NLQ0Tk0zSjI3tzSwsDAy8xYXSWsIZGRYMiWJiZEBAkF8NobMvOKSxAoGBgBtrR8v"));

  Future<void> initializeAgora() async {
    await _client.initialize();
  }

  AgoraClient get getClient => _client;
}
