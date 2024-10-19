import 'package:instax/core/use_cases/use_case.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/repositories/user_repository.dart';

class DeleteMessageUseCase
    implements UseCaseThreeParams<void, Message, Message, bool> {
  final FireStoreUserRepository _userRepository;

  DeleteMessageUseCase(this._userRepository);
  @override
  Future<void> call(
          {required Message paramsOne,
          required Message paramsTwo,
          required bool paramsThree}) =>
      _userRepository.deleteMessage(
          messageInfo: paramsOne,
          replacedMessage: paramsTwo,
          isThatOnlyMessageInChat: paramsThree);
}
