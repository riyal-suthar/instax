import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/calling_room_repository.dart';

class CreateCallingRoomUseCase
    extends UseCaseTwoParams<String, UserPersonalInfo, List<UserPersonalInfo>> {
  final CallingRoomRepository _callingRoomRepository;

  CreateCallingRoomUseCase(this._callingRoomRepository);

  @override
  Future<String> call(
          {required UserPersonalInfo paramsOne,
          required List<UserPersonalInfo> paramsTwo}) async =>
      await _callingRoomRepository.createCallingRoom(
          myPersonalInfo: paramsOne, callThoseUsersInfo: paramsTwo);
}
