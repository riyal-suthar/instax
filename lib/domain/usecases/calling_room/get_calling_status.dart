import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/calling_room_repository.dart';

class GetCallingStatusUseCase extends StreamUseCase<bool, String> {
  final CallingRoomRepository _callingRoomRepository;

  GetCallingStatusUseCase(this._callingRoomRepository);

  @override
  Stream<bool> call({required String params}) =>
      _callingRoomRepository.getCallingStatus(channelUid: params);
}
