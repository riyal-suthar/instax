import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/calling_room_repository.dart';

class JoinToCallingRoomUseCase
    extends UseCaseTwoParams<String, String, UserPersonalInfo> {
  final CallingRoomRepository _callingRoomRepository;

  JoinToCallingRoomUseCase(this._callingRoomRepository);

  @override
  Future<String> call(
          {required String paramsOne, required UserPersonalInfo paramsTwo}) =>
      _callingRoomRepository.joinToRoom(
          channelId: paramsOne, myPersonalInfo: paramsTwo);
}
