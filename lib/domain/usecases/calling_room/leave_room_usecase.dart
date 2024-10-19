import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/calling_room_repository.dart';

class CancelJoiningToRoomUseCase
    extends UseCaseThreeParams<void, String, String, bool> {
  final CallingRoomRepository _callingRoomRepository;

  CancelJoiningToRoomUseCase(this._callingRoomRepository);

  @override
  Future<void> call(
          {required String paramsOne,
          required String paramsTwo,
          required bool paramsThree}) =>
      _callingRoomRepository.leaveTheRoom(
          userId: paramsOne,
          channelId: paramsTwo,
          isThatAfterJoining: paramsThree);
}
