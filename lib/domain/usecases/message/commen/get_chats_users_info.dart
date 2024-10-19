import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/sender_receiver_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetChatUsersInfoAddMessageUseCase
    implements UseCase<List<SenderInfo>, UserPersonalInfo> {
  final FireStoreUserRepository _userRepository;

  GetChatUsersInfoAddMessageUseCase(this._userRepository);
  @override
  Future<List<SenderInfo>> call({required UserPersonalInfo params}) =>
      _userRepository.getChatUserInfo(myPersonalInfo: params);
}
