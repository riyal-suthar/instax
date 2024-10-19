import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/domain/entities/sender_receiver_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class GetSpecificChatInfoUseCase
    implements UseCaseTwoParams<SenderInfo, String, bool> {
  final FireStoreUserRepository _userRepository;

  GetSpecificChatInfoUseCase(this._userRepository);

  @override
  Future<SenderInfo> call(
          {required String paramsOne, required bool paramsTwo}) =>
      _userRepository.getSpecificChatInfo(
          chatUid: paramsOne, isThatGroup: paramsTwo);
}
