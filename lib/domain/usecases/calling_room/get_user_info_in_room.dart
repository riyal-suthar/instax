import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/entities/call_meet.dart';
import 'package:instax/domain/repositories/calling_room_repository.dart';

class GetUsersInfoInRoomUseCase
    extends UseCase<List<UsersInfoInCallingRoom>, String> {
  final CallingRoomRepository _callingRoomRepository;

  GetUsersInfoInRoomUseCase(this._callingRoomRepository);

  @override
  Future<List<UsersInfoInCallingRoom>> call({required String params}) =>
      _callingRoomRepository.getUsersInfoInThisRoom(channelId: params);
}
