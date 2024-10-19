import 'package:instax/domain/repositories/agora_video_call_repository.dart';

class GetCallChannelIdUseCase {
  final CallRepository repository;

  const GetCallChannelIdUseCase({required this.repository});

  Future<String> call(String uid) async {
    return await repository.getCallChannelId(uid);
  }
}
