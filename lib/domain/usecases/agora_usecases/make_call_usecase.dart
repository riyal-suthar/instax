import 'package:instax/domain/entities/call_entity.dart';
import 'package:instax/domain/repositories/agora_video_call_repository.dart';

class MakeCallUseCase {
  final CallRepository repository;

  const MakeCallUseCase({required this.repository});

  Future<void> call(CallEntity call) async {
    return await repository.makeCall(call);
  }
}
