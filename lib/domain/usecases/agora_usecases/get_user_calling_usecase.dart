import 'package:instax/domain/entities/call_entity.dart';
import 'package:instax/domain/repositories/agora_video_call_repository.dart';

class GetUserCallingUseCase {
  final CallRepository repository;

  const GetUserCallingUseCase({required this.repository});

  Stream<List<CallEntity>> call(String uid) {
    return repository.getUserCalling(uid);
  }
}
