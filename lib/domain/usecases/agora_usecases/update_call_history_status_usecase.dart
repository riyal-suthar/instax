import 'package:instax/domain/entities/call_entity.dart';
import 'package:instax/domain/repositories/agora_video_call_repository.dart';

class UpdateCallHistoryStatusUseCase {
  final CallRepository repository;

  const UpdateCallHistoryStatusUseCase({required this.repository});

  Future<void> call(CallEntity call) async {
    return await repository.updateCallHistoryStatus(call);
  }
}
