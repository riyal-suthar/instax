import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/repositories/calling_room_repository.dart';

class DeleteTheRoomUseCase
    extends UseCaseTwoParams<void, String, List<dynamic>> {
  final CallingRoomRepository _callingRoomRepository;

  DeleteTheRoomUseCase(this._callingRoomRepository);

  @override
  Future<void> call({required String paramsOne, required List paramsTwo}) =>
      _callingRoomRepository.deleteRoom(
          channelId: paramsOne, usersIds: paramsTwo);
}
